# 育種学会2015秋　若手の会ワークショップ

育種学会2015秋季大会で開催された若手の会ワークショップにでの講演「植物器官の効率的フェノタイピング：画像解析と形態測定学」のサンプルコード及びデータ．

## リンク
* [サポートページ](https://koji.noshita.net/page/morphometrics/workshop2015_jsb.html)
* [コードとデータ| GitHub](https://github.com/noshita/wsJBS2015Aut.git)
* [ワークショップ](https://sites.google.com/a/ut-biomet.org/jsb-2015autumn-workshop/home)

## 構成

- img
	* grapevine オリジナル画像．Climate and developmental plasticity: interannual variability in grapevine leaf morphology([doi:10.7910/DVN/KOG6SY](http://dx.doi.org/10.7910/DVN/KOG6SY))のサブセット．
		* [Specimen Num].jpg
	* binarized 二値画像
		* [Specimen Num].jpg
- coord 各標本・各葉の輪郭の座標データ
	* [Specimen Num]_[Leaf Num].csv
- ij Fiji関連
	* classifiler_01.model [Trainable Weka Segmentation](http://imagej.net/Trainable_Weka_Segmentation)の判別器．
	* classifiler_02.model 01より汎化させた判別器．
	* outlines.py 二値画像から輪郭の座標値を出力するPythonスクリプト．Fijiから呼び出し使う．
- efa.r 楕円フーリエ解析用Rスクリプト
- README.md