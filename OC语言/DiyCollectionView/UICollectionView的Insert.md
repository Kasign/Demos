
 ---->>>>>>>>didSelectItemAtIndexPath

 *->>insert : 0 - 3

 1、SectionNum---->>>>numberOfSectionsInCollectionView

 2、ItemsNum---->>>>numberOfItemsInSection section:0

 5、itemSize---->>>>sizeForItemAtIndexPath index:<NSIndexPath: 0xccf4341f88008837> {length = 2, path = 0 - 0}

 5、itemSize---->>>>sizeForItemAtIndexPath index:<NSIndexPath: 0xccf4341f88208837> {length = 2, path = 0 - 1}

 5、itemSize---->>>>sizeForItemAtIndexPath index:<NSIndexPath: 0xccf4341f88408837> {length = 2, path = 0 - 2}

 5、itemSize---->>>>sizeForItemAtIndexPath index:<NSIndexPath: 0xccf4341f88608837> {length = 2, path = 0 - 3}

 5、itemSize---->>>>sizeForItemAtIndexPath index:<NSIndexPath: 0xccf4341f88808837> {length = 2, path = 0 - 4}

 5、itemSize---->>>>sizeForItemAtIndexPath index:<NSIndexPath: 0xccf4341f88a08837> {length = 2, path = 0 - 5}

 5、itemSize---->>>>sizeForItemAtIndexPath index:<NSIndexPath: 0xccf4341f88c08837> {length = 2, path = 0 - 6}

 5、itemSize---->>>>sizeForItemAtIndexPath index:<NSIndexPath: 0xccf4341f88e08837> {length = 2, path = 0 - 7}

 5、itemSize---->>>>sizeForItemAtIndexPath index:<NSIndexPath: 0xccf4341f89008837> {length = 2, path = 0 - 8}

 8、inset---->>>>insetForSectionAtIndex section:0

 7、InteritemSpacing---->>>>minimumInteritemSpacingForSectionAtIndex section:0

 6、LineSpacing---->>>>minimumLineSpacingForSectionAtIndex section:0

 9、SizeForHeader---->>>>referenceSizeForHeaderInSection section:0

 10、SizeForFooter---->>>>referenceSizeForFooterInSection section:0

 3、cell---->>>>cellForItemAtIndexPath index:<NSIndexPath: 0xccf4341f88608837> {length = 2, path = 0 - 3}

总结：
layout:插入cell的时候，刷新整个布局信息
collectionView:刷新新加入的cell