#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

uniform vec2 mouse;

const int   complexity = 20;
const float fluid_speed = 10.0;
const float color_intensity = 0.8;
const float red = 0.8;
const float green = 0.9;
const float blue = 0.3;

void main()
{
  vec2 p = (2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);
  for(int i = 1; i < complexity; i++)
  {
    vec2 newp = p + time*0.001;
    newp.x += 0.7/float(i)*sin(float(i)*p.y+time/fluid_speed+float(i));
    newp.y += 0.7/float(i)*sin(float(i)*p.x+time/fluid_speed+float(i));
    p = newp;
  }
  vec3 col = vec3(red*sin(3.0*p.x), green*sin(3.0*p.x), blue*sin(3.0*p.x));
  gl_FragColor = vec4(col, 1.0);
}
