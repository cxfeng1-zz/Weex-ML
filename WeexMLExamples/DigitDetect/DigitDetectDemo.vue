<template>
  <div class="wrapper" >
    <div class="button" @click="clear">
      <text :style="{color:'#ffffff'}">Clear Canvas</text>
    </div>
    <div :style="{borderWidth:'4px',backgroundColor:'black',margin: '20px'}">
      <gcanvas ref="canvas" class="pad" @touchstart="touchstart" @touchmove="touchmove" @touchend="touchend"></gcanvas>
    </div>
    <div>
      <text class="title">{{result.identifier}}</text>
    </div>
  </div>
</template>

<style scoped>
  .wrapper {align-items: center; margin-top: 120px;}
  .title {font-size: 64px;margin-top:20px;font-style: bold}
  .pad {width: 600px; height: 400px; }
  .button {width:500px; height: 100px; background-color:#0E639C; margin-top:50px; align-items: center;justify-content: center;}
</style>

<script>
  var gcanvas=require('weex-gcanvas');
  module.exports = {
    data: {
      imageURL: 'https://source.unsplash.com/collection/237954/2',
      result:{},
      canvasOriginX:0,
      canvasOriginY:0,
      swiped:true,
      lastPointX:0,
      lastPointY:0,
      ctx:undefined,
    },
    methods: {
      predict: function (e) {
        let digitRecognition = weex.requireModule('digitDetect')
        digitRecognition.predictWithCanvas(this.$refs.canvas.ref, (results)=>{
          this.result = results[0];
        })
      },
      touchstart: function(e) {
        this.swiped = false
        let touch = e.changedTouches[0]
        var self = this
        weex.requireModule('dom').getComponentRect(this.$refs.canvas.ref, (res)=>{
          this.canvasOriginX = res.size.left
          this.canvasOriginY = res.size.top
          console.log(`canvasOrigin:${this.canvasOriginX},${this.canvasOriginY}`)
          this.lastPointX = touch.pageX-this.canvasOriginX
          this.lastPointY = touch.pageY-this.canvasOriginY
          console.log(`start:${this.lastPointX},${this.lastPointY}`)
          if (self.ctx === undefined) {
            gcanvas.start(this.$refs.canvas.ref, function () {
              self.ctx = gcanvas.getContext('2d');
              console.log(this.ctx)
            });
          }
        })
      },
      touchmove: function(e) {
        this.swiped = true
        let touch = e.changedTouches[0]
        let currentPointX = touch.pageX-this.canvasOriginX
        let currentPointY = touch.pageY-this.canvasOriginY
        console.log(`move:${currentPointX},${currentPointY}`)
        this.drawLine(this.lastPointX, this.lastPointY, currentPointX, currentPointY, ()=>{
          this.lastPointX = currentPointX
          this.lastPointY = currentPointY
        })

      },
      touchend: function(e) {
        this.predict()
      },
      drawLine: function(startPointX, startPointY, endPointX, endPointY, finish) {
        var ref = this.$refs.canvas.ref;
        var ctx = this.ctx;
        // ctx.fillStyle = 'black';
        // ctx.fillRect(startPointX, startPointY, endPointX, endPointY);
        ctx.beginPath();
        ctx.strokeStyle="#ffffff"
        ctx.lineWidth=20;
        ctx.lineCap="round"
        ctx.moveTo(startPointX, startPointY);
        ctx.lineTo(endPointX, endPointY);
        ctx.stroke();
        finish()
      },
      clear: function() {
        console.log("clear...")
        this.ctx.clearRect(0, 0, 600, 400)
      },
    }
  }
</script>
