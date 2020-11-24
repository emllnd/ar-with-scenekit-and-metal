//
//  SimpleShader.metal
//  smTest
//
//  Created by Emil on 24.11.2020.
//

/*#include <metal_stdlib>
using namespace metal;

// Define the Vertex data structure. This corresponds to the TriangleVertex struct
// that was defined in Swift
struct Vertex
{
    float4 position [[position]];
    float4 color;
};

// The vertices aren't transformed.
vertex Vertex passthrough_vertex(device Vertex *vertices [[buffer(0)]],
                   uint vid [[vertex_id]])
{
    return vertices[vid];
}

// No fancy effects, just use the vertex color that was defined.
fragment float4 passthrough_fragment(Vertex inVertex [[stage_in]])
{
    return inVertex.color;
}*/
