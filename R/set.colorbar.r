set.colorbar <- function(cbx,cby,pal='jet',zlim,ticks=1:10,labels=ticks,gradient,oticks,cb.title="",cb.xlab="",font=1,cex=1,
                         cex.cb.title=0.9,cex.cb.xlab=0.8,cex.cb.ticks=0.7,
                         cb.ticks.srt=90,cb.ticks.length, cb.ticks.ypos, cb.ticks.lwd=1, integer=F,cb.xlab.line=0,...){
  #   #inst.pkg('plotrix')
  if(!missing(zlim)) ticks <- pretty(zlim)
  cex.cb.title <- cex*cex.cb.title
  cex.cb.xlab <- cex*cex.cb.xlab
  cex.cb.ticks <- cex*cex.cb.ticks
    
  if(missing(cbx) | missing(cby)) cbx <- cby <- 1
  
  if(length(cbx) != 2 | length(cby) != 2){
    warning('colorbar positions missing or not of correct length (cbx and/or cby)!',immediate. = T)
    add <- list()
    cat("\nPlease select the lower left colorbar-position by the mouse cursor.")
    p1 <- locator(n=1)
    add$cbx1 <- p1$x
    add$cby1 <- p1$y
    
    cat("\nPlease select the upper right colorbar-position by the mouse cursor.")
    #       cat("\nDon't select large cby2-value as procedure is tick-mark procedure is optimized for small cby2-cby1.")
    #cat('\n(example colorbar based on selected points will be shown later)')
    p2 <- locator(n=1)
    add$cbx2 <- p2$x
    add$cby2 <- p2$y
    
    cbx <- range(c(add$cbx1,add$cbx2))
    cby <- range(c(add$cby1,add$cby2))
    cat(paste(paste("selected colorbar positions (can be entered also as argument!):\ncbx "),paste(cbx,collapse=" "), "\ncby ",paste(cby,collapse=" ")),'\n')
  }
  
  if(missing(gradient)){    
    grads <- abs(diff(cby))-abs(diff(cbx))    
    gradient <- c('x','y')[((grads > 0)+1)]
  }else{
    if(gradient %in% c('v', 'vertical')) gradient <- 'x'
    if(gradient %in% c('h', 'horizontal')) gradient <- 'y'
  }
  
  ## testing colorbar values
  if(length(pal) == 1){
    cmap <- NULL
    rm(cmap)
    data("cmap",envir=environment())
    
    if(!(pal %in% names(cmap))) {
      pal <- "jet"
      warning('no valid color map selection, "pal" was reset to "jet"! available color maps:\n',paste(names(cmap),collapse='\n'))
    }
    cpalette <- cmap[[pal]]
  }else{
    cpalette <- pal
  }
  
  color.legend(cbx[1],cby[1],cbx[2],cby[2],"", cpalette,align="rb",gradient=gradient,xpd=T) #xl,yb,xr,yt
  
  if(gradient == 'x'){
    oticks <- "b"
    ticks.xpos <- seq(cbx[1],cbx[2],length=length(ticks)) # set tick positions
    
    if(integer){ # get centered ticks
          r <- seq(cbx[1],cbx[2],length.out=length(pal)+1)
          r2 <- seq(cbx[1],cbx[2],diff(r)[1]/2)
          ticks.xpos <- r2[which(!(r2 %in% r))]
          if(missing(labels)) labels <- unique(pal)
    }
    
    cby.diff <- min(c(diff(par()$usr[1:2]),diff(par()$usr[3:4])))
    pos <- get.cb.pos(cbx,cby,oticks)
    if(!missing(cb.ticks.ypos)) pos$ticks.lab <- cb.ticks.ypos
    if(!missing(cb.ticks.length)) pos$ticks.length <- cb.ticks.length
    if(pos$ticks.length[1] != 0) for(n in 1:length(ticks)) lines(c(ticks.xpos[n],ticks.xpos[n]),pos$ticks.length,xpd=T)
    for(n in 1:length(ticks)) text(ticks.xpos[n],pos$ticks.lab,labels[n],cex=cex.cb.ticks,xpd=T) #plot labels
    
    text((cbx[1]+cbx[2])/2,pos$cb.title,cb.title,cex=cex.cb.title,xpd=T,font=font,...)
    text((cbx[1]+cbx[2])/2,pos$cb.xlab+cb.xlab.line*diff(par()$usr[3:4])/10,cb.xlab,cex=cex.cb.xlab,xpd=T,font=font,...)
  }else{
    if(missing(oticks)) oticks <- c('l','r')[((mean(cbx) > mean(par()$usr[1:2]))+1)]
    ticks.ypos <- seq(cby[1],cby[2],length=length(ticks)) # set tick positions
    pos <- get.cb.pos(cbx,cby,oticks=oticks)
    for(n in 1:length(ticks))
    {
      lines(pos$ticks.length,c(ticks.ypos[n],ticks.ypos[n]),xpd=T,lwd=cb.ticks.lwd)
      text(pos$ticks.lab,ticks.ypos[n],labels[n],cex=cex.cb.ticks,xpd=T,srt=cb.ticks.srt)        
    }
    text((cbx[1]+cbx[2])/2,pos$cb.title,cb.title,cex=cex.cb.title,xpd=T,font=font,...)
    text(pos$cb.xlab+cb.xlab.line*diff(par()$usr[1:2])/10,(cby[1]+cby[2])/2,cb.xlab,cex=cex.cb.xlab,xpd=T,srt=90,font=font,...)
  }
  align <- list()
  align$oticks <- oticks
  align$gradient <- gradient
  align$cbx <- cbx
  align$cby <- cby
  return(align)
}