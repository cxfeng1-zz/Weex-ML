<template>
  <div class="wrapper" >
    <div class="button" @click="change">
      <text :style="{color:'#ffffff'}">Change Photo</text>
    </div>
    
      <image ref="image" :src="imageURL" class="logo" @click="predict" @load="imageLoad">
        <gcanvas ref="canvas" class="pad" @touchstart="touchstart" @touchmove="touchmove" @touchend="touchend"></gcanvas>
      </image>
  </div>
</template>

<style scoped>
  .wrapper {align-items: center; margin-top: 120px;}
  .title {font-size: 32px;margin-top:20px}
  .logo {width: 500px; height: 500px;margin: 50px}
  .pad {width: 500px; height: 500px}
  .button {width:500px; height: 100px; background-color:#0E639C; margin-top:50px; align-items: center;justify-content: center;}
</style>

<script>
  var gcanvas=require('weex-gcanvas')
  module.exports = {
    data: {
      imageURL: 'https://source.unsplash.com/collection/265985/500x500',
      results:[],
      ctx:undefined
    },
    mounted: function() {
      let self = this
      gcanvas.start(this.$refs.canvas.ref, function () {
        self.ctx = gcanvas.getContext('2d');
      });
    },
    methods: {
      detect: function (e) {
        let faceDetect = weex.requireModule('faceDetect')
        let self = this
        faceDetect.detectLandmarks(this.$refs.image.ref, (results)=>{
          this.ctx.translate(0,500)
          this.ctx.scale(1,-1)
          results.forEach(function(result) {
            let boundingBox = result.boundingBox
            console.log(`bounding box:${JSON.stringify(boundingBox)}`)
            let ctx = self.ctx
            ctx.beginPath();
            ctx.lineWidth="6";
            ctx.strokeStyle="red";    
            ctx.rect(boundingBox.x,boundingBox.y,boundingBox.width,boundingBox.height);
            ctx.stroke();
            for (let key in result) {
              if (result.hasOwnProperty(key) && key !== "boundingBox") {
                ctx.beginPath();
                ctx.lineWidth="3"
                ctx.strokeStyle="yellow"
                ctx.lineCap="round"
                let region = result[key]
                let lastX = region[0].x
                let lastY = region[0].y
                console.log(key + JSON.stringify(region))
                for (let i = 1; i < region.length; i++) {
                  ctx.moveTo(lastX, lastY)
                  ctx.lineTo(region[i].x, region[i].y)
                  ctx.stroke();
                  lastX = region[i].x
                  lastY = region[i].y
                } 

                ctx.moveTo(lastX, lastY)
                ctx.lineTo(region[0].x, region[0].y)
              }
            }
          }, this);
        })
      },
      change: function(e) {
        this.ctx.clearRect(0, 0, 500, 500)
        let index = Math.floor(Math.random() * 120)
        this.imageURL = 'https://source.unsplash.com/collection/580685/' + index
      },
      imageLoad: function(e) {
        this.detect()
      },
    }
  }
</script>
