# CircularCollectionView
[教程](https://www.raywenderlich.com/107687/uicollectionview-custom-layout-tutorial-spinning-wheel)
##一脸蒙蔽
每次只要是开始做自定义CollectionView的时候，都会被复杂的计算公式所迷惑，这次还是一样。😢总有些计算过程让我无头看起，然后demo却一笔带过，我只是想知道这些计算过程是如何思考出来的，不然自己怎么渔呢。
##原理
本次demo是在横屏模式下，一个旋转的卡片视角模式。　　　　　　　　　　　　　　　　　

新建继承于UICollectionViewLayout的自定义类CircularCollectionViewLayout
设置cell的大小  ```let itemSize = CGSize(width: 133, height: 173)```
设置半径 ```var radius: CGFloat = 500 {didSet {invalidateayout();} }```
###第一步：旋转
如何让每一张卡片进行不同角度的旋转
需要计算出每一张卡片的角度 ```var anglePerItem: CGFloat { return atan(itemSize.width / radius) }``` 这个角度可以是任何值，该值看上去使每个卡片不这么分散，
