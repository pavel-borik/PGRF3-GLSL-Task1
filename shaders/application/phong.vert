#version 120
in vec2 inPosition;
varying vec3 viewDirection, lightDirection, normal;
varying float dist;
uniform int object;
uniform mat4 modelMat, viewMat, projMat;
uniform vec3 eyePos;
const float PI = 3.1415926535897932384626433832795;
float r,s,t;

vec3 createObject(vec2 uv);
vec3 normalDiff (vec2 uv);

void main() {
    vec4 position = vec4(createObject(inPosition),1.0 );
    mat4 mvp = projMat * viewMat * modelMat;

    normal = normalDiff(inPosition);
    normal = (dot(normal,position.xyz) < 0.0) ? normal : -normal;

    vec4 lightPosition = vec4(-20.0, 10.0, 4.0, 1.0);
    //vec4 objectPosition =  gl_ModelViewMatrix * position;
    vec4 objectPosition =  viewMat * modelMat * position;

    lightDirection = normalize(lightPosition.xyz - objectPosition.xyz);
    viewDirection = - objectPosition.xyz;
    dist = length(lightDirection);
	gl_Position = mvp * vec4(createObject(inPosition), 1.0);
}

vec3 createObject (vec2 uv) {
    switch(object) {
        case 0:
            s = 2 * PI * uv.x; //theta
            t = PI * uv.y; //phi
            r = 7;
            return vec3(r * cos(t)*sin(s), r * sin(t)*sin(s), r * cos(s));
        case 1:
            s = 2* PI * uv.x;
            t = 2* PI * uv.y;
            r = t;
            return vec3(r * cos(s), r * sin(s) ,2*sin(t));
        case 2:
             s = 2*PI*uv.x;
             t = 17*uv.y;
             return vec3(t, 6/pow(t+1,0.7)*cos(s), 6/pow(t+1,0.7)*sin(s));
    }
    return vec3(0,0,0);
}

vec3 normalDiff (vec2 uv){
    float delta = 0.0001;
    vec3 dzdu = (createObject(inPosition+vec2(delta,0))-createObject(inPosition-vec2(delta,0)));
    vec3 dzdv = (createObject(inPosition+vec2(0,delta))-createObject(inPosition-vec2(0,delta)));
    return cross(dzdu,dzdv);
}