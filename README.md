# Weex-ML
Weex modules for machine learning based on CoreML and Vision framework in iOS.

# Requirements
* Xcode 9+
* iOS 11.0+

# Demo
1. Install and setup [CocoaPods](http://guides.cocoapods.org/), if it's not done yet
2. Run `pod install` 
3. Open `WeexMLExamples.xcworkspace` in XCode and run the project.

# Modules

## imageRecognition

Detects  an image from a set of 1000 categories such as trees, animals, food, vehicles, person etc, using [Inceptionv3](https://github.com/fchollet/keras/blob/0bb4e0fad5b4bb3743c8a7d03c260b62a35e7045/keras/applications/inception_v3.py) model.

```javascript
let imageRecognition = weex.requireModule('imageRecognition')
imageRecognition.predictWithImage(this.$refs.image.ref, (results)=>{
  this.results = results.slice(0,5);
})
```

## digitDetect 

Classifies handwritten digit.

```javascript
let digitRecognition = weex.requireModule('digitDetect')
digitRecognition.predictWithCanvas(this.$refs.canvas.ref, (results)= {
  this.result = results[0];
})
```

## faceDetect

An image analysis module that finds facial features (such as the eyes and mouth) in an image.

```javascript
let faceDetect = weex.requireModule('faceDetect')
faceDetect.detectLandmarks(this.$refs.image.ref, (results)=>{
  results.forEach(function(result) {
    // face landmarks result
  }, this);
})
```

