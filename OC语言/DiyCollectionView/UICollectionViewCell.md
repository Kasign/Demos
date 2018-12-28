-------------------------********-------------------------

当前类名：UICollectionViewCell

实例方法：(
    ".cxx_destruct",
    dealloc,
    "encodeWithCoder:",
    "initWithCoder:",
    prepareForReuse,
    "_gestureRecognizerShouldBegin:",
    layoutSubviews,
    isHighlighted,
    backgroundView,
    "systemLayoutSizeFittingSize:withHorizontalFittingPriority:verticalFittingPriority:",
    canBecomeFocused,
    "canPerformAction:withSender:",
    "setSemanticContentAttribute:",
    "_descendent:didMoveFromSuperview:toSuperview:",
    "_descendent:willMoveFromSuperview:toSuperview:",
    "setContentView:",
    "_preferredConfigurationForFocusAnimation:inContext:",
    "_encodableSubviews",
    "setBackgroundView:",
    "_updateBackgroundView",
    "_setContentView:addToHierarchy:",
    selectedBackgroundView,
    "setSelectedBackgroundView:",
    "_setLayoutAttributes:",
    "setEditing:",
    "_contentViewFrame",
    "_selectionAnimationDuration",
    "_shouldSaveOpaqueStateForView:",
    "_isUsingOldStyleMultiselection",
    "_setSelected:animated:",
    "_selectionSegueTemplate",
    "_setHighlighted:animated:",
    "_setLayoutEngineSuspended:",
    "_didUpdateFocusInContext:withAnimationCoordinator:",
    "_setDragState:",
    "_updateHighlightColorsForView:highlight:",
    "_setupHighlightingSupport",
    "_descendantsShouldHighlight",
    "_setOpaque:forSubview:",
    "_updateHighlightColorsForAnimationHalfwayPoint",
    "_highlightDescendantsWhenSelected",
    "_teardownHighlightingSupportIfReady",
    "_updateFocusedFloatingContentControlStateAnimated:",
    "dragStateDidChange:",
    "_updateGhostedAppearance",
    "_dragState",
    "_menuDismissed:",
    "_performAction:sender:",
    "_updateFocusedFloatingContentControlStateInContext:withAnimationCoordinator:animated:",
    "_canFocusProgrammatically",
    "_ensureFocusedFloatingContentView",
    "_isLayoutEngineSuspended",
    isDragging,
    "_handleMenuGesture:",
    "cut:",
    "copy:",
    "paste:",
    "_setSelectionSegueTemplate:",
    "_forwardsSystemLayoutFittingSizeToContentView:",
    "_focusStyle",
    "_setFocusStyle:",
    "setDragging:",
    contentView,
    "sizeThatFits:",
    isEditing,
    "initWithFrame:",
    "setHighlighted:",
    "setSelected:",
    isSelected
)

类方法：(
    "_contentViewClass"
)

成员变量和属性:{
    "_backgroundView" = "@\"UIView\"";
    "_collectionCellFlags" = "{?=\"selected\"b1\"highlighted\"b1\"showingMenu\"b1\"clearSelectionWhenMenuDisappears\"b1\"waitingForSelectionAnimationHalfwayPoint\"b1\"contentViewWantsSystemLayoutSizeFittingSize\"b1}";
    "_contentView" = "@\"UIView\"";
    "_dragState" = q;
    "_dragging" = B;
    "_focusStyle" = q;
    "_focusedFloatingContentView" = "@\"_UIFloatingContentView\"";
    "_highlighted" = B;
    "_highlightingSupport" = "@";
    "_isLayoutEngineSuspended" = B;
    "_menuGesture" = "@\"UILongPressGestureRecognizer\"";
    "_selected" = B;
    "_selectedBackgroundView" = "@\"UIView\"";
    "_selectionSegueTemplate" = "@";
}

属性:{
    "_dragState" = "Tq,N,G_dragState,S_setDragState:";
    "_layoutEngineSuspended" = "TB,N,G_isLayoutEngineSuspended,S_setLayoutEngineSuspended:,V_isLayoutEngineSuspended";
    backgroundView = "T@\"UIView\",&,N,V_backgroundView";
    contentView = "T@\"UIView\",&,N,V_contentView";
    contentViewFrame = "T{CGRect={CGPoint=dd}{CGSize=dd}},R,N,G_contentViewFrame";
    debugDescription = "T@\"NSString\",R,C";
    description = "T@\"NSString\",R,C";
    dragging = "TB,N,GisDragging,V_dragging";
    focusStyle = "Tq,N,G_focusStyle,S_setFocusStyle:,V_focusStyle";
    hash = "TQ,R";
    highlighted = "TB,N,GisHighlighted,V_highlighted";
    selected = "TB,N,GisSelected,V_selected";
    selectedBackgroundView = "T@\"UIView\",&,N,V_selectedBackgroundView";
    selectionAnimationDuration = "Td,R,N,G_selectionAnimationDuration";
    superclass = "T#,R";
}

协议列表：(
    UIGestureRecognizerDelegate,
    "_UILayoutEngineSuspending"
)

-------------------------********-------------------------