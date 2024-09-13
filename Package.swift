// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "oneTBB",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v11), .iOS(.v13)
    ],
    products: [
        .library(
            name: "oneTBB",
            targets: ["OneTBB", "TBBMalloc", "TBBMallocProxy"])
    ],
    targets: [
        .target(
            name: "TBBMallocProxy",
            dependencies: [
                .target(name: "OneTBB"),
            ],
            path: ".",
            exclude: ["src/tbbmalloc_proxy/tbbmalloc_proxy.rc", "src/tbbmalloc_proxy/CMakeLists.txt"],
            sources: ["src/tbbmalloc_proxy"],
            publicHeadersPath: "include",
            cxxSettings: [
                .define("_XOPEN_SOURCE", to: "1"),
                .define("TBBPROXY_NO_DLLMAIN")
            ]
        ),

        .target(
            name: "TBBMalloc",
            dependencies: [
                .target(name: "OneTBB"),
                .target(name: "TBBMallocProxy"),
            ],
            path: ".",
            exclude: ["src/tbbmalloc/tbbmalloc.rc", "src/tbbmalloc/def", "src/tbbmalloc/CMakeLists.txt"],
            sources: ["src/tbbmalloc"],
            publicHeadersPath: ".",
            cxxSettings: [
                .define("_XOPEN_SOURCE", to: "1"),
                .define("__TBBMALLOC_BUILD", to: "1"),
                .define("TBBMALLOC_NO_DLLMAIN")
            ]
        ),

        .target(
            name: "OneTBB",
            path: ".",
            exclude: ["src/tbb/tbb.rc", "src/tbb/CMakeLists.txt"],
            sources: ["src/tbb"],
            publicHeadersPath: "include",
            cxxSettings: [
                .define("_XOPEN_SOURCE", to: "1"),
                .define("__TBB_BUILD"),
                .define("TBB_NO_LIB_LINKAGE")
            ]
        ),
    ],
    cxxLanguageStandard: .cxx20
)
