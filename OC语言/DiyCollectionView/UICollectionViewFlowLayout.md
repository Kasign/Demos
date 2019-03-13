
-------------------------********-------------------------

当前类名：UICollectionViewFlowLayout

实例方法：(
    ".cxx_destruct",
    "encodeWithCoder:",
    "initWithCoder:",
    init,
    "setMinimumLineSpacing:",
    "setEstimatedItemSize:",
    "_setCollectionView:",
    "invalidationContextForBoundsChange:",
    "invalidateLayoutWithContext:",
    finalizeCollectionViewUpdates,
    "indexPathForItemAtPoint:",
    prepareLayout,
    "shouldInvalidateLayoutForBoundsChange:",
    "layoutAttributesForElementsInRect:",
    "layoutAttributesForItemAtIndexPath:",
    "layoutAttributesForSupplementaryViewOfKind:atIndexPath:",
    collectionViewContentSize,
    "_shouldScrollToContentBeginningInRightToLeft",
    "shouldInvalidateLayoutForPreferredLayoutAttributes:withOriginalAttributes:",
    "invalidationContextForPreferredLayoutAttributes:withOriginalAttributes:",
    "_estimatesSizes",
    "_willPerformUpdateVisibleCellsPass",
    "_didPerformUpdateVisibleCellsPass",
    "_contentOffsetForScrollingToSection:",
    "_focusFastScrollingIndexBarInsets",
    developmentLayoutDirection,
    "_cellsShouldConferWithAutolayoutEngineForSizingInfo",
    scrollDirection,
    itemSize,
    "setItemSize:",
    "setScrollDirection:",
    "_resetCachedItems",
    "_getSizingInfosWithExistingSizingDictionary:",
    "_updateItemsLayoutForRect:allowsPartialUpdate:",
    "_fetchItemsInfoForRect:",
    "indexesForSectionHeadersInRect:usingData:",
    "indexesForSectionFootersInRect:usingData:",
    "_frameForHeaderInSection:usingData:",
    "_frameForFooterInSection:usingData:",
    "_existingLayoutAttributesForItemAtIndexPath:",
    "_frameForItem:inSection:usingData:",
    "_fetchAndCacheNewLayoutAttributesForCellWithIndexPath:frame:",
    "layoutAttributesForHeaderInSection:usingData:",
    "layoutAttributesForFooterInSection:usingData:",
    "_sectionArrayIndexForIndexPath:",
    "layoutAttributesForItemAtIndexPath:usingData:",
    "_boundsAndInsetsAreValidForReferenceDimension",
    "_layoutAttributesForItemsInRect:",
    "_updateCollectionViewScrollableAxis",
    "_dimensionFromCollectionView",
    "_effectiveEstimatedItemSize",
    "_adjustedSectionInsetForSectionInset:forAxis:",
    minimumInteritemSpacing,
    minimumLineSpacing,
    "_updateDelegateFlags",
    "_headerFollowsSectionMargins",
    "_footerFollowsSectionMargins",
    sectionInset,
    "layoutAttributesForHeaderInSection:",
    "indexesForSectionHeadersInRect:",
    "indexesForSectionFootersInRect:",
    "layoutAttributesForFooterInSection:",
    "_calculateAttributesForRect:",
    "setMinimumInteritemSpacing:",
    "setHeaderReferenceSize:",
    "setFooterReferenceSize:",
    "setSectionInset:",
    "_setNeedsLayoutComputationWithoutInvalidation",
    "initialLayoutAttributesForInsertedItemAtIndexPath:",
    "initialLayoutAttributesForHeaderInInsertedSection:",
    "initialLayoutAttributesForFooterInInsertedSection:",
    "finalLayoutAttributesForDeletedItemAtIndexPath:",
    "finalLayoutAttributesForHeaderInDeletedSection:",
    "finalLayoutAttributesForFooterInDeletedSection:",
    synchronizeLayout,
    "_invalidateButKeepDelegateInfo",
    "_invalidateButKeepAllInfo",
    "_setRowAlignmentsOptions:",
    "_rowAlignmentOptions",
    "_updateContentSizeScrollingDimensionWithDelta:",
    "_setRoundsToScreenScale:",
    "_roundsToScreenScale",
    "_setHeaderFollowsSectionMargins:",
    "_setFooterFollowsSectionMargins:",
    "setSectionHeadersPinToVisibleBounds:",
    sectionHeadersPinToVisibleBounds,
    "setSectionFootersPinToVisibleBounds:",
    sectionFootersPinToVisibleBounds,
    headerReferenceSize,
    footerReferenceSize,
    estimatedItemSize,
    sectionInsetReference,
    "setSectionInsetReference:"
)

类方法：(
    invalidationContextClass
)

成员变量和属性:{
    "_cachedItemAttributes" = "@\"NSMutableDictionary\"";
    "_cachedItemFrames" = "@\"NSMutableDictionary\"";
    "_contentOffsetAdjustment" = "{CGPoint=\"x\"d\"y\"d}";
    "_contentSizeAdjustment" = "{CGSize=\"width\"d\"height\"d}";
    "_currentLayoutSize" = "{CGSize=\"width\"d\"height\"d}";
    "_data" = "@\"_UIFlowLayoutInfo\"";
    "_deletedItemsAttributesDict" = "@\"NSMutableDictionary\"";
    "_deletedSectionFootersAttributesDict" = "@\"NSMutableDictionary\"";
    "_deletedSectionHeadersAttributesDict" = "@\"NSMutableDictionary\"";
    "_estimatedItemSize" = "{CGSize=\"width\"d\"height\"d}";
    "_footerReferenceSize" = "{CGSize=\"width\"d\"height\"d}";
    "_gridLayoutFlags" = "{?=\"delegateSizeForItem\"b1\"delegateReferenceSizeForHeader\"b1\"delegateReferenceSizeForFooter\"b1\"delegateInsetForSection\"b1\"delegateInteritemSpacingForSection\"b1\"delegateLineSpacingForSection\"b1\"delegateAlignmentOptions\"b1\"layoutDataIsValid\"b1\"delegateInfoIsValid\"b1\"roundsToScreenScale\"b1\"delegateSizesForSection\"b1\"sectionHeadersFloat\"b1\"sectionFootersFloat\"b1\"headerFollowsSectionMargins\"b1\"footerFollowsSectionMargins\"b1\"fetchingItemsInfoForRect\"b1\"isInUpdateVisibleCellsPass\"b1}";
    "_headerReferenceSize" = "{CGSize=\"width\"d\"height\"d}";
    "_indexPathsToValidate" = "@\"NSMutableArray\"";
    "_insertedItemsAttributesDict" = "@\"NSMutableDictionary\"";
    "_insertedSectionFootersAttributesDict" = "@\"NSMutableDictionary\"";
    "_insertedSectionHeadersAttributesDict" = "@\"NSMutableDictionary\"";
    "_interitemSpacing" = d;
    "_itemSize" = "{CGSize=\"width\"d\"height\"d}";
    "_lineSpacing" = d;
    "_rowAlignmentsOptionsDictionary" = "@\"NSDictionary\"";
    "_scrollDirection" = q;
    "_sectionInset" = "{UIEdgeInsets=\"top\"d\"left\"d\"bottom\"d\"right\"d}";
    "_sectionInsetReference" = q;
    "_updateVisibleCellsContext" = "@\"_UIUpdateVisibleCellsContext\"";
}

属性:{
    estimatedItemSize = "T{CGSize=dd},N,V_estimatedItemSize";
    estimatesSizes = "TB,R,N,G_estimatesSizes";
    footerReferenceSize = "T{CGSize=dd},N,V_footerReferenceSize";
    headerReferenceSize = "T{CGSize=dd},N,V_headerReferenceSize";
    itemSize = "T{CGSize=dd},N,V_itemSize";
    minimumInteritemSpacing = "Td,N,V_interitemSpacing";
    minimumLineSpacing = "Td,N,V_lineSpacing";
    scrollDirection = "Tq,N";
    sectionFootersPinToVisibleBounds = "TB,N";
    sectionHeadersPinToVisibleBounds = "TB,N";
    sectionInset = "T{UIEdgeInsets=dddd},N,V_sectionInset";
    sectionInsetReference = "Tq,N,V_sectionInsetReference";
}

协议列表：(
)

-------------------------********-------------------------
