////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package mx.automation.delegates.controls 
{
import flash.display.DisplayObject;
import flash.events.Event;

import mx.automation.Automation;
import mx.automation.IAutomationObjectHelper;
import mx.automation.delegates.core.UIComponentAutomationImpl;
import mx.controls.treeClasses.TreeItemRenderer;
import mx.core.mx_internal;
import mx.core.UITextField;

use namespace mx_internal;

[Mixin]
/**
 * 
 *  Defines methods and properties required to perform instrumentation for the 
 *  TreeItemRenderer class.
 * 
 *  @see mx.controls.treeClasses.TreeItemRenderer 
 *
 */
public class TreeItemRendererAutomationImpl extends UIComponentAutomationImpl 
{
    include "../../../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Registers the delegate class for a component class with automation manager.
     */
    public static function init(root:DisplayObject):void
    {
        Automation.registerDelegateClass(TreeItemRenderer, TreeItemRendererAutomationImpl);
    }   

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     * @param obj TreeItemRenderer object to be automated.     
     */
    public function TreeItemRendererAutomationImpl(obj:TreeItemRenderer)
    {
        super(obj);
    }

    //----------------------------------
    //  treeItem
    //----------------------------------

    /**
     *  @private
     *  storage for the owner component
     */
    protected function get treeItem():TreeItemRenderer
    {
        return uiComponent as TreeItemRenderer;
    }
    
    //----------------------------------
    //  automationName
    //----------------------------------
   
    /**
     *  @private
     */
    override public function get automationName():String
    {
        return treeItem.getLabel().text || super.automationName;
    }
    

    //----------------------------------
    //  automationValue
    //----------------------------------
   
    /**
     *  @private
     */
    override public function get automationValue():Array
    {
        return [ treeItem.getLabel().text ];
    }

}
}