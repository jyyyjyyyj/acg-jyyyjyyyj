#version 120

// see the GLSL 1.2 specification:
// https://www.khronos.org/registry/OpenGL/specs/gl/GLSLangSpec.1.20.pdf

#define PI 3.1415926538

varying vec3 normal;  // normal vector pass to the rasterizer
uniform float cam_z_pos;  // camera z position specified by main.cpp

void main()
{
    normal = vec3(gl_Normal); // set normal

    // "gl_Vertex" is the *input* vertex coordinate of triangle.
    // "gl_Position" is the *output* vertex coordinate in the
    // "canonical view volume (i.e.. [-1,+1]^3)" pass to the rasterizer.
    // type of "gl_Vertex" and "gl_Position" are "vec4", which is homogeneious coordinate

    gl_Position = gl_Vertex; // following code do nothing (input == output)

    float x0 = gl_Vertex.x; // x-coord
    float y0 = gl_Vertex.y; // y-coord
    float z0 = gl_Vertex.z; // z-coord
    // modify code below to define transformation from input (x0,y0,z0) to output (x1,y1,z1)
    // such that after transformation, orthogonal z-projection will be fisheye lens effect
    // Specifically, achieve equidistance projection (https://en.wikipedia.org/wiki/Fisheye_lens)
    // the lens is facing -Z direction and lens's position is at (0,0,cam_z_pos)
    // the lens covers all the view direction
    // the "back" direction (i.e., +Z direction) will be projected as the unit circle in XY plane.
    // in GLSL, you can use built-in math function (e.g., sqrt, atan).
    // look at page 56 of https://www.khronos.org/registry/OpenGL/specs/gl/GLSLangSpec.1.20.pdf
    
    float z_tmp = z0-cam_z_pos;
    float t = 1/sqrt(x0*x0+y0*y0+z_tmp*z_tmp);
    float x1 = t*x0;
    float y1 = t*y0;
    //float z1 = cam_z_pos + t*z_tmp;
    float z1 = z0;
    
    /*
    I have a question here:
    
    From my perspective, what we should do is to project the coordinates onto a unit sphere whose origin is
    (0,0,cam_z_pos).

    However, it seems that the colors of the mesh polygons will become discontinuous if I change the value of z1.
    Should z change together with x and y?
    Maybe there is something wrong with my implementation.
    */

    
    gl_Position = vec4(x1,y1,z1,1); // homogenious coordinate
}
