//
//  ViewController.swift
//  smTest
//
//  Created by Emil on 24.11.2020.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
  
    private var pipelineState: MTLRenderPipelineState!
    private var vertexBuffer: MTLBuffer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
  
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMetalResources()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
  
  
    // MARK: - SceneKit and Metal
  
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        // Used to encode additional rendering commands after SceneKit has drawn its content.
        guard let encoder = sceneView.currentRenderCommandEncoder else { return }
        
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
    }
  
    func setupMetalResources() {
        guard let device = sceneView.device else {
            assertionFailure()
            return
        }
        
        // We're drawing a simple triangle so we only need a position and a color
        struct TriangleVertex {
            var position: vector_float4
            var color: vector_float4
        }
        
        // Define the triangle's vertices and colors
        let vertices: [TriangleVertex] = [
            // Top triangle, red color
            TriangleVertex(position: vector_float4( 0.0, 0.5, 0, 1), color: vector_float4(1, 0, 0, 1)),
            // Bottom left triangle, green color
            TriangleVertex(position: vector_float4( -0.5, -0.5, 0, 1), color: vector_float4(0, 1, 0, 1)),
            // Bottom right triangle, blue color
            TriangleVertex(position: vector_float4( 0.5, -0.5, 0, 1), color: vector_float4(0, 0, 1, 1))
        ]
        // Create the vertex buffer
        self.vertexBuffer = device.makeBuffer(
            bytes: vertices,
            length: MemoryLayout<TriangleVertex>.size * vertices.count,
            options: .cpuCacheModeWriteCombined)
        
        // Set up the shaders
        let library = device.makeDefaultLibrary()
        let vertexFunc = library?.makeFunction(name: "passthrough_vertex")
        let fragmentFunc = library?.makeFunction(name: "passthrough_fragment")
        
        // Create the pipeline descriptor
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        // Use SCNView's pixel format
        pipelineDescriptor.colorAttachments[0].pixelFormat = sceneView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = sceneView.depthPixelFormat
        
        guard let pipeline = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        else {
            assertionFailure()
            return
        }
        
        self.pipelineState = pipeline
    }
}
