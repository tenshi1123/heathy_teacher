allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Chỉ áp dụng ép kiểu JVM Target cho thư viện bị lỗi để tránh ảnh hưởng thư viện khác
subprojects {
    if (project.name == "screen_protector") {
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            kotlinOptions {
                jvmTarget = "17"
            }
        }
    }
    
    // Fix Namespace và JVM Target cho image_gallery_saver trên AGP 8+
    if (project.name == "image_gallery_saver") {
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            kotlinOptions {
                jvmTarget = "1.8"
            }
        }
        afterEvaluate {
            val androidExtension = extensions.findByName("android")
            if (androidExtension != null) {
                try {
                    val setNamespace = androidExtension.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespace.invoke(androidExtension, "com.example.imagegallerysaver")
                } catch (e: Exception) {
                    // Bỏ qua nếu có lỗi
                }
            }
        }
    }
}