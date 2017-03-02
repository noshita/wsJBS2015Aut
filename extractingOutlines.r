#=====================================================
#
# extractingOutlines.r
#
#=====================================================

# -- Momocs -- #
# MomocsをGitHubから導入
devtools::install_github("vbonhomme/Momocs", build_vignettes= TRUE)
# Momocsのロード
library(Momocs)


# -- 輪郭データ準備 -- #
# 画像データの一括読み込み
imgDir <- "./img/binarized"
imgFiles <- list.files(imgDir)
imgFiles <- grep('^[0-9a-z]+.jpg$',imgFiles,value=TRUE)
imgFiles <- sapply(imgFiles,function(x) {paste(imgDir,x,sep="/")})
imgData <- import_jpg(imgFiles)

# 座標データを輪郭形式に変換
grapevine <- coo_close(Out(imgData))