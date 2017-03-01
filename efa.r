#=====================================================
#
# efa.r
#
#=====================================================

# -- 作業ディレクトリの設定 -- #
# 現在の作業ディレクトリの確認
getwd()

# 作業ディレクトリが`設置した場所/wsJBS2015Aut`になっていない場合
#
#「"作業ディレクトリ名"」に作業ディレクトリのパスを設定する
# Macでユーザー名「username」でホームディレクトリに設置した場合
# workingdir <- /Users/username/wsJBS2015Aut
workingdir <- "作業ディレクトリ名"
setwd(workingdir)

# -- Momocs -- #
# MomocsをGitHubから導入
devtools::install_github("vbonhomme/Momocs", build_vignettes= TRUE)
# Momocsのロード
library(Momocs)

# -- 輪郭データ準備 -- #
# データの一括読み込み
coordDir <- "./coord"
coordFiles <- list.files(coordDir)
coordFiles <- grep('^[0-9a-z]+_[0-9]+.csv$',coordFiles,value=TRUE)
coordFiles <- sapply(coordFiles,function(x) {paste(coordDir,x,sep="/")})
coordData <- import_txt(coordFiles, header=FALSE, sep=",",col.names=c("x","y"))

# 座標データを輪郭形式に変換
grapevine <- coo_close(Out(coordData))

# データの表示
stack(grapevine)

# -- 楕円フーリエ解析 -- #
# 規格化
# 位置
grapevine.preform <- coo_center(grapevine)
# サイズ
grapevine.preshape <- Out(sapply(grapevine.preform$coo, function(x){x/sqrt(coo_area(x))}))
# 向き
grapevine.shape <- coo_align(grapevine.preshape)
grapevine.shape <- coo_slidedirection(grapevine.shape, "E")

# データの一覧を表示
panel(grapevine.shape,names = TRUE)

# 必要に応じて向きを調整する
# 特定の`coo`を回転し，始点を再設定する
rotateAnOutline <- function(shape,angle){
  tmpShape <- coo_rotate(shape, theta = angle)
  tmpShape <- coo_slidedirection(tmpShape, "E")
  return(tmpShape)
}
# 回転角を確認
checkRotationBatch <- function(listOfIndexesAndAngles, outlines){
  num <- length(listOfIndexesAndAngles)
  sqrt(num)
  num.inRow <- ceiling(sqrt(num))
  num.inCol <- ceiling(num/num.inRow)
  par.old <- par(mfrow=c(num.inCol,num.inRow))
  lapply(listOfIndexesAndAngles,function(x){coo_plot(rotateAnOutline(outlines[x[1]],x[2]))})
  par(par.old)
}
# まとめて差し替え
replaceBatch <- function(listOfIndexesAndAngles, outlines){
  tmp <- outlines
  for(val in listOfIndexesAndAngles){
    tmp[val[[1]]] <- rotateAnOutline(outlines[val[1]],val[2])
  }
  return(tmp)
}

# 回転角を確認
replaceList <- list(c(3,-pi/6),c(5,-pi/16),c(16,pi/16),c(17,-pi/2-pi/8),c(18,-pi/2-pi/6),c(19,-pi/2),c(20,-pi/4),c(21,-pi/2),
                    c(22,-pi/2+pi/8),c(23,-pi/2+pi/8),c(24,-pi/2+pi/8),c(26,-pi/2+pi/16),c(27,-pi/4-pi/16),c(28,-pi/4-pi/32),
                    c(29,-pi/2),c(30,-pi/2),c(31,pi/8),c(32,-pi/8),c(33,-pi/2),c(34,pi/4),c(35,-pi/2),c(36,-pi/2-pi/8))
checkRotationBatch(replaceList, grapevine.shape)
# 回転を決定し，データを差し替え
grapevine.shape.realign <- replaceBatch(replaceList, grapevine.shape)
# 全体の確認
panel(grapevine.shape.realign,names = TRUE)

# 楕円フーリエ解析
# 今回は既に規格化しているのでnormオプションをFALSEにしている
grapevine.efc <-efourier(grapevine.shape.realign, 100, norm = FALSE)

# -- 可視化 -- #
# 主成分分析
grapevine.pca <- PCA(grapevine.efc)

# PCAの結果の可視化
plot(grapevine.pca)
plot3(grapevine.pca)
PCcontrib(grapevine.pca)

# 輪郭形状の再構築
grapevine.efi <- as.Out(grapevine.efc)
# 可視化
# 特定の葉
plotComp <- function(index,shape,efi){
  coo_plot(shape[index])
  coo_draw(efi[index], border='red', col=NA)
}
# 全体
plotCompAll <- function(shape, efi){
  num <- length(shape)
  sqrt(num)
  num.inRow <- ceiling(sqrt(num))
  num.inCol <- ceiling(num/num.inRow)
  par.old <- par(mfrow=c(num.inCol,num.inRow))
  lapply(1:num, function(x){plotComp(x, shape, efi)})
  par(par.old)
}

# 特定の葉
plotComp(12, grapevine.shape.realign, grapevine.efi)
# 全体
plotCompAll(grapevine.shape.realign, grapevine.efi)