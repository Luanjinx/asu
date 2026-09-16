import com.android.build.gradle.BaseExtension
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    project.layout.buildDirectory.value(newBuildDir.dir(project.name))
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    configurations.configureEach {
        exclude(group = "com.google.android.gms", module = "play-services-tapandpay")
        exclude(group = "com.revenuecat.purchases", module = "purchases-store-amazon")
    }
}

subprojects {
    plugins.withId("com.android.library") {
        if (!plugins.hasPlugin("org.jetbrains.kotlin.android") &&
            file("src/main/kotlin").isDirectory
        ) {
            apply(plugin = "org.jetbrains.kotlin.android")
        }
    }
}

subprojects {
    val configureProject = { p: Project ->
        val androidExt = p.extensions.findByName("android") as? BaseExtension
        if (androidExt != null) {
            runCatching {
                androidExt.compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
            }
            val currentSdk = androidExt.compileSdkVersion?.filter { it.isDigit() } ?: ""
            if (currentSdk.isEmpty() || currentSdk.toInt() < 36) {
                androidExt.compileSdkVersion(36)
            }
        }
        p.tasks.withType<KotlinCompile>().configureEach {
            compilerOptions {
                jvmTarget.set(JvmTarget.JVM_17)
            }
        }
    }

    if (project.state.executed) {
        configureProject(project)
    } else {
        project.afterEvaluate {
            configureProject(project)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
