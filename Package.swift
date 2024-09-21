// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "oneTBB",
    platforms: [
        .macOS(.v11), .iOS(.v13)
    ],
    products: [
        .library(
            name: "oneTBB",

            // Targets are named this way to get SPM to not think there is an "umbrella header"
            targets: ["tbb_target", "tbbmalloc_target", "tbbmalloc_proxy_target"])
    ],
    targets: [
        .target(
            name: "tbbmalloc_proxy_target",
            dependencies: [
                .target(name: "tbb_target"),
            ],
            path: ".",
            exclude: ["examples", "src/tbbmalloc_proxy/tbbmalloc_proxy.rc", "src/tbbmalloc_proxy/CMakeLists.txt"],
            sources: ["src/tbbmalloc_proxy"],
            publicHeadersPath: "include",
            cxxSettings: [
                .define("_XOPEN_SOURCE", to: "1"),
                .define("TBBPROXY_NO_DLLMAIN")
            ]
        ),

        .target(
            name: "tbbmalloc_target",
            dependencies: [
                .target(name: "tbb_target"),
                .target(name: "tbbmalloc_proxy_target"),
            ],
            path: ".",
            exclude: ["examples", "src/tbbmalloc/tbbmalloc.rc", "src/tbbmalloc/def", "src/tbbmalloc/CMakeLists.txt"],
            sources: ["src/tbbmalloc"],
            publicHeadersPath: ".",
            cxxSettings: [
                .define("_XOPEN_SOURCE", to: "1"),
                .define("__TBBMALLOC_BUILD", to: "1"),
                .define("TBBMALLOC_NO_DLLMAIN")
            ]
        ),

        .target(
            name: "tbb_target",
            path: ".",
            exclude: ["examples", "src/tbb/tbb.rc", "src/tbb/CMakeLists.txt"],
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
