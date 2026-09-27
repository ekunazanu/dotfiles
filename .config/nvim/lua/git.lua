-- diff base is fetched once per buffer (async, HEAD:<path>) and cached;
-- subsequent updates only run vim.diff() locally, so no git process is

local group = vim.api.nvim_create_augroup('UserGitSigns', { clear = true })

local signs = {
    add = '+',
    change = '~',
    delete = '-',
}

-- bufnr -> { base, tracked, timer, lines = { [lnum] = sign } }
local state = {}

local function get_state(bufnr)
    local s = state[bufnr]
    if not s then
        s = {}
        state[bufnr] = s
    end
    return s
end

local function redraw(bufnr)
    pcall(vim.api.nvim__redraw, { buf = bufnr, statuscolumn = true })
end

local function render(bufnr)
    local s = state[bufnr]
    if not s or not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end
    if not s.tracked or not s.base then
        if s.lines and next(s.lines) then
            s.lines = {}
            redraw(bufnr)
        end
        return
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local buf_text = table.concat(lines, '\n') .. '\n'

    local ok, hunks = pcall(vim.diff, s.base, buf_text, {
        result_type = 'indices',
        algorithm = 'myers',
    })

    local marks = {}
    if ok and hunks then
        for _, hunk in ipairs(hunks) do
            local count_a, start_b, count_b = hunk[2], hunk[3], hunk[4]
            if count_a == 0 and count_b > 0 then
                for i = start_b, start_b + count_b - 1 do
                    marks[i] = signs.add
                end
            elseif count_b == 0 then
                marks[math.max(start_b, 1)] = signs.delete
            else
                local changed = math.min(count_a, count_b)
                for i = start_b, start_b + changed - 1 do
                    marks[i] = signs.change
                end
                if count_b > count_a then
                    for i = start_b + changed, start_b + count_b - 1 do
                        marks[i] = signs.add
                    end
                elseif count_a > count_b then
                    marks[start_b + count_b - 1] = signs.delete
                end
            end
        end
    end

    s.lines = marks
    redraw(bufnr)
end

_G.GSSC = function()
    local s = state[vim.api.nvim_get_current_buf()]
    return (s and s.lines and s.lines[vim.v.lnum]) or ' '
end

local function schedule_render(bufnr)
    local s = get_state(bufnr)
    if not s.timer then
        s.timer = vim.uv.new_timer()
    end
    s.timer:stop()
    s.timer:start(150, 0, vim.schedule_wrap(function()
        render(bufnr)
    end))
end

local function load_base(bufnr)
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == '' or vim.bo[bufnr].buftype ~= '' then
        return
    end

    local dir = vim.fs.dirname(path)
    vim.system({ 'git', '-C', dir, 'rev-parse', '--show-toplevel' }, { text = true }, function(root_out)
        if root_out.code ~= 0 then
            return
        end
        local root = vim.trim(root_out.stdout)
        local relpath = path:sub(#root + 2)

        vim.system({ 'git', '-C', root, 'show', 'HEAD:' .. relpath }, { text = true }, function(show_out)
            vim.schedule(function()
                local s = get_state(bufnr)
                if show_out.code == 0 then
                    s.base = show_out.stdout
                    s.tracked = true
                    render(bufnr)
                else
                    s.tracked = false
                    s.base = nil
                    render(bufnr)
                end
            end)
        end)
    end)
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'FocusGained', 'ShellCmdPost' }, {
    group = group,
    callback = function(args)
        load_base(args.buf)
    end,
})

vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
    group = group,
    callback = function(args)
        schedule_render(args.buf)
    end,
})

vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
    group = group,
    callback = function(args)
        local s = state[args.buf]
        if s and s.timer then
            s.timer:stop()
            s.timer:close()
        end
        state[args.buf] = nil
    end,
})

for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
        load_base(buf)
    end
end
