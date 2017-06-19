// { "framework": "Vue" }

/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ({

/***/ 0:
/***/ function(module, exports, __webpack_require__) {

	var __vue_exports__, __vue_options__
	var __vue_styles__ = []

	/* styles */
	__vue_styles__.push(__webpack_require__(491)
	)

	/* script */
	__vue_exports__ = __webpack_require__(492)

	/* template */
	var __vue_template__ = __webpack_require__(493)
	__vue_options__ = __vue_exports__ = __vue_exports__ || {}
	if (
	  typeof __vue_exports__.default === "object" ||
	  typeof __vue_exports__.default === "function"
	) {
	if (Object.keys(__vue_exports__).some(function (key) { return key !== "default" && key !== "__esModule" })) {console.error("named exports are not supported in *.vue files.")}
	__vue_options__ = __vue_exports__ = __vue_exports__.default
	}
	if (typeof __vue_options__ === "function") {
	  __vue_options__ = __vue_options__.options
	}
	__vue_options__.__file = "/Users/admin/Workspace/incubator-weex/examples/vue/hello.vue"
	__vue_options__.render = __vue_template__.render
	__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
	__vue_options__._scopeId = "data-v-e8e6c37a"
	__vue_options__.style = __vue_options__.style || {}
	__vue_styles__.forEach(function (module) {
	  for (var name in module) {
	    __vue_options__.style[name] = module[name]
	  }
	})
	if (typeof __register_static_styles__ === "function") {
	  __register_static_styles__(__vue_options__._scopeId, __vue_styles__)
	}

	module.exports = __vue_exports__
	module.exports.el = 'true'
	new Vue(module.exports)


/***/ },

/***/ 491:
/***/ function(module, exports) {

	module.exports = {
	  "wrapper": {
	    "alignItems": "center",
	    "marginTop": 120
	  },
	  "title": {
	    "fontSize": 32,
	    "marginTop": 20
	  },
	  "logo": {
	    "width": 500,
	    "height": 500,
	    "margin": 50
	  },
	  "button": {
	    "width": 500,
	    "height": 100,
	    "backgroundColor": "#0E639C",
	    "marginTop": 50,
	    "alignItems": "center",
	    "justifyContent": "center"
	  }
	}

/***/ },

/***/ 492:
/***/ function(module, exports) {

	'use strict';

	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//

	module.exports = {
	  data: {
	    imageURL: 'https://source.unsplash.com/collection/325839/500x500',
	    results: []
	  },
	  methods: {
	    predict: function predict(e) {
	      var _this = this;

	      var imageRecognition = weex.requireModule('imageRecognition');
	      imageRecognition.predictWithImage(this.$refs.image.ref, function (results) {
	        _this.results = results.slice(0, 5);
	      });
	    },
	    change: function change(e) {
	      var index = Math.floor(Math.random() * 100);
	      this.imageURL = 'https://source.unsplash.com/collection/325839/' + index;
	    },
	    imageLoad: function imageLoad(e) {
	      this.predict();
	    }
	  }
	};

/***/ },

/***/ 493:
/***/ function(module, exports) {

	module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
	  return _c('div', {
	    staticClass: ["wrapper"]
	  }, [_c('div', {
	    staticClass: ["button"],
	    on: {
	      "click": _vm.change
	    }
	  }, [_c('text', {
	    style: {
	      color: '#ffffff'
	    }
	  }, [_vm._v("Change Photo")])]), _c('image', {
	    ref: "image",
	    staticClass: ["logo"],
	    attrs: {
	      "src": _vm.imageURL
	    },
	    on: {
	      "click": _vm.predict,
	      "load": _vm.imageLoad
	    }
	  }), _vm._l((_vm.results), function(result) {
	    return _c('div', [_c('text', {
	      staticClass: ["title"]
	    }, [_vm._v(_vm._s(result.identifier) + ": " + _vm._s(Math.round(result.confidence * 1000) / 1000))])])
	  })], 2)
	},staticRenderFns: []}
	module.exports.render._withStripped = true

/***/ }

/******/ });