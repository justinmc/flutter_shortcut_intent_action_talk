'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "9c6362e1d1825e283a19f53f37a8911e",
"index.html": "180f77c83c968095e63723a3018d15cf",
"/": "180f77c83c968095e63723a3018d15cf",
"main.dart.js": "c1890334ece5778b2f88ab6fee2abc12",
"flutter.js": "8ae00b472ec3937a5bee52055d6bc8b4",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "fd7c59537d1d40be77b078a18eaf5397",
"assets/AssetManifest.json": "42e8057b52ccc54f74fe1f7d28303689",
"assets/docs/assets/docs/web/assets/assets/tool_pencil.png": "a33138604d2368f154eb1a236e838702",
"assets/docs/assets/docs/web/assets/assets/actions_screenshot.png": "fe38ab23090ef68780ec820b04111336",
"assets/docs/assets/docs/web/assets/assets/paint_screenshot.png": "61eceb7584921305fa2dd61a1df2599f",
"assets/docs/assets/docs/web/assets/assets/tool_pointer.png": "78ecd89cdd8057481b4928662c8fc6a4",
"assets/docs/assets/docs/web/assets/assets/shortcuts_screenshot.png": "97b5d6791881795ec92ed291be0615ee",
"assets/docs/assets/docs/web/assets/assets/tool_circle.png": "870972af810451d47c40c24e4ee2b7ab",
"assets/docs/assets/docs/web/assets/assets/tool_selection.png": "c452c32365813681903c3d294f85c16d",
"assets/docs/assets/docs/web/assets/assets/text_field_screenshot.png": "499ef3f14aff7216f338d551f1cb823a",
"assets/docs/assets/docs/web/assets/assets/tool_rectangle.png": "8452404dcee4c8ef52d52eba7e30deb9",
"assets/docs/assets/docs/web/assets/assets/tool_text.png": "98de5fbb9e0b8d1f86019a9f63c9b0df",
"assets/docs/assets/docs/assets/assets/tool_pencil.png": "a33138604d2368f154eb1a236e838702",
"assets/docs/assets/docs/assets/assets/actions_screenshot.png": "fe38ab23090ef68780ec820b04111336",
"assets/docs/assets/docs/assets/assets/paint_screenshot.png": "61eceb7584921305fa2dd61a1df2599f",
"assets/docs/assets/docs/assets/assets/tool_pointer.png": "78ecd89cdd8057481b4928662c8fc6a4",
"assets/docs/assets/docs/assets/assets/shortcuts_screenshot.png": "97b5d6791881795ec92ed291be0615ee",
"assets/docs/assets/docs/assets/assets/tool_circle.png": "870972af810451d47c40c24e4ee2b7ab",
"assets/docs/assets/docs/assets/assets/tool_selection.png": "c452c32365813681903c3d294f85c16d",
"assets/docs/assets/docs/assets/assets/text_field_screenshot.png": "499ef3f14aff7216f338d551f1cb823a",
"assets/docs/assets/docs/assets/assets/tool_rectangle.png": "8452404dcee4c8ef52d52eba7e30deb9",
"assets/docs/assets/docs/assets/assets/tool_text.png": "98de5fbb9e0b8d1f86019a9f63c9b0df",
"assets/docs/assets/assets/tool_squiggle.png": "92c895a757750a0113ba2672582036a5",
"assets/docs/assets/assets/tool_magnifier.png": "86d7eb93890661295e906cfbc858002a",
"assets/docs/assets/assets/tool_pencil.png": "a33138604d2368f154eb1a236e838702",
"assets/docs/assets/assets/actions_screenshot.png": "fe38ab23090ef68780ec820b04111336",
"assets/docs/assets/assets/tool_polygon_selection.png": "2dde05ea434fdaafc78951fa1dcc64b9",
"assets/docs/assets/assets/tool_spray.png": "188cbf737ca741a078ffd0f05c19c891",
"assets/docs/assets/assets/paint_screenshot.png": "23c9bd7582a8e6eee7a34674a2ac14c9",
"assets/docs/assets/assets/tool_picker.png": "172c9d83d0a4383598eb05083a21fd72",
"assets/docs/assets/assets/tool_oval.png": "719788842fee69aff4c4232c7174d3dd",
"assets/docs/assets/assets/tool_can.png": "8357a7dd54fa9d54427d6e2e0a547b3c",
"assets/docs/assets/assets/tool_polygon.png": "7b7066b25e2ce04248be459ec3424791",
"assets/docs/assets/assets/tool_pointer.png": "78ecd89cdd8057481b4928662c8fc6a4",
"assets/docs/assets/assets/tool_eraser.png": "be7fd1b56318c0a7b83a643aecf636e1",
"assets/docs/assets/assets/shortcuts_screenshot.png": "97b5d6791881795ec92ed291be0615ee",
"assets/docs/assets/assets/tool_circle.png": "870972af810451d47c40c24e4ee2b7ab",
"assets/docs/assets/assets/tool_selection.png": "c452c32365813681903c3d294f85c16d",
"assets/docs/assets/assets/text_field_screenshot.png": "499ef3f14aff7216f338d551f1cb823a",
"assets/docs/assets/assets/tool_line.png": "64ff64fb05ab5e6d469c2c49ef7893f2",
"assets/docs/assets/assets/tool_rectangle.png": "8452404dcee4c8ef52d52eba7e30deb9",
"assets/docs/assets/assets/tool_text.png": "98de5fbb9e0b8d1f86019a9f63c9b0df",
"assets/docs/assets/assets/tool_paint.png": "09581d33daf8b9021013f275871d1748",
"assets/NOTICES": "1a4051a4eaffba658d6150d9197f5e69",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/shaders/ink_sparkle.frag": "2ad5fabd6a36a6deff087b8edfd0c1f8",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/assets/tool_squiggle.png": "92c895a757750a0113ba2672582036a5",
"assets/assets/tool_magnifier.png": "86d7eb93890661295e906cfbc858002a",
"assets/assets/tool_pencil.png": "a33138604d2368f154eb1a236e838702",
"assets/assets/actions_screenshot.png": "fe38ab23090ef68780ec820b04111336",
"assets/assets/tool_polygon_selection.png": "2dde05ea434fdaafc78951fa1dcc64b9",
"assets/assets/tool_spray.png": "188cbf737ca741a078ffd0f05c19c891",
"assets/assets/paint_screenshot.png": "23c9bd7582a8e6eee7a34674a2ac14c9",
"assets/assets/tool_picker.png": "172c9d83d0a4383598eb05083a21fd72",
"assets/assets/tool_oval.png": "719788842fee69aff4c4232c7174d3dd",
"assets/assets/tool_can.png": "8357a7dd54fa9d54427d6e2e0a547b3c",
"assets/assets/tool_polygon.png": "7b7066b25e2ce04248be459ec3424791",
"assets/assets/tool_pointer.png": "78ecd89cdd8057481b4928662c8fc6a4",
"assets/assets/tool_eraser.png": "be7fd1b56318c0a7b83a643aecf636e1",
"assets/assets/shortcuts_screenshot.png": "97b5d6791881795ec92ed291be0615ee",
"assets/assets/tool_circle.png": "870972af810451d47c40c24e4ee2b7ab",
"assets/assets/tool_selection.png": "c452c32365813681903c3d294f85c16d",
"assets/assets/text_field_screenshot.png": "499ef3f14aff7216f338d551f1cb823a",
"assets/assets/tool_line.png": "64ff64fb05ab5e6d469c2c49ef7893f2",
"assets/assets/tool_rectangle.png": "8452404dcee4c8ef52d52eba7e30deb9",
"assets/assets/tool_text.png": "98de5fbb9e0b8d1f86019a9f63c9b0df",
"assets/assets/tool_paint.png": "09581d33daf8b9021013f275871d1748",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
