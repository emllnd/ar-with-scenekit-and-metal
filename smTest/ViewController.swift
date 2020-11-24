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
  
    private var pointCloudRenderer: Renderer!
    
    //private var pipelineState: MTLRenderPipelineState!
    //private var vertexBuffer: MTLBuffer!
    
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
      
        configuration.frameSemantics = .sceneDepth

        // Run the view's session
        sceneView.session.run(configuration)
    }
  
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        pointCloudRenderer = Renderer(
            session: sceneView.session,
            metalDevice: sceneView.device!,
            sceneView: sceneView)
        pointCloudRenderer.drawRectResized(size: sceneView.bounds.size)
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
  
    /*func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        pointCloudRenderer.update()
    }*/
  
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        pointCloudRenderer.draw()
    }
}
