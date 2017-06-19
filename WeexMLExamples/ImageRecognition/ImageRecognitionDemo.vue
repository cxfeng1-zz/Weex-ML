<template>
  <div class="wrapper" >
    <div class="button" @click="change">
      <text :style="{color:'#ffffff'}">Change Photo</text>
    </div>
    <image ref="image" :src="imageURL" class="logo" @click="predict" @load="imageLoad"></image>
    <div v-for="result in results">
      <text class="title">{{result.identifier}}: {{Math.round(result.confidence*1000)/1000}}</text>
    </div>
  </div>
</template>

<style scoped>
  .wrapper {align-items: center; margin-top: 120px;}
  .title {font-size: 32px;margin-top:20px}
  .logo {width: 500px; height: 500px;margin: 50px}
  .button {width:500px; height: 100px; background-color:#0E639C; margin-top:50px; align-items: center;justify-content: center;}
</style>

<script>
  module.exports = {
    data: {
      imageURL: 'https://source.unsplash.com/collection/325839/500x500',
      results:[]
    },
    methods: {
      predict: function (e) {
        let imageRecognition = weex.requireModule('imageRecognition')
        imageRecognition.predictWithImage(this.$refs.image.ref, (results)=>{
          this.results = results.slice(0,5);
        })
      },
      change: function(e) {
        let index = Math.floor(Math.random() * 100)
        this.imageURL = 'https://source.unsplash.com/collection/325839/' + index
      },
      imageLoad: function(e) {
        this.predict()
      },
    }
  }
</script>
