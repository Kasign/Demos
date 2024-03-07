#
# Be sure to run `pod lib lint FlyBaseTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlyBaseTool'
  s.version          = '0.1.0'
  s.summary          = 'A short description of FlyBaseTool.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Kasign/FlyBaseTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kasign' => '393890129@qq.com' }
  s.source           = { :git => 'https://github.com/Kasign/FlyBaseTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.frameworks = 'Foundation', 'UIKit'
  s.prefix_header_file = "#{s.name}/Classes/FlyBaseToolPrefix.pch"
  s.source_files = 'FlyBaseTool/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FlyBaseTool' => ['FlyBaseTool/Assets/*.png']
  # }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.vendored_frameworks = '#{s.name}/Classes/Framework/*.framework'
  s.vendored_libraries = '#{s.name}/Classes/Framework/*.a'

  s.preserve_paths = "#{s.name}/Classes/**/*", 
                     "#{s.name}/Resource/**/*",
                     "#{s.name}/Assets/**/*",
                     "#{s.name}/Framework/**/*",
                     "#{s.name}/Archive/**/*",
                     "#{s.name}/Dependencies/**/*"
                     
  s.default_subspec = "All"

  #依赖
  _Dependency = [
    # {:name => 'BMUI'},
    # {:name => 'TZImagePickerController'}
  ]
  
  configuration = "Debug"
  if ENV["IS_DEBUG"] || ENV["#{s.name}_DEBUG"]
    configuration = "Debug"
  elsif ENV["IS_RELEASE"] || ENV["#{s.name}_RELEASE"]
    configuration = "Release"
  end

  # 拆分子库
  _Base = {
    :spec_name => "Base",
    :resource_bundle => {
         "Base" => ["#{s.name}/Classes/Base/Resource/**/*", "#{s.name}/Classes/Base/Resource/**/*.{xcassets}"]
    }
  }

  # _AB = {
  #   :spec_name => "AB",
  #   :sub_dependency => [_Base],
  #   :resource_bundle => {
  #        "#{s.name}_AB" => ["#{s.name}/Classes/AB/Resource/**/*", "#{s.name}/Classes/AB/Resource/**/*.{xcassets}"]
  #   }
  # }

  # _Upload = {
  #   :spec_name => "Upload",
  #   :sub_dependency => [_Base],
  #   :resource_bundle => {
  #        "#{s.name}_Upload" => ["#{s.name}/Classes/Upload/Resource/**/*", "#{s.name}/Classes/Upload/Resource/**/*.{xcassets}"]
  #   }
  # }

  _All = {
    :spec_name => "All",
    :noSource => true,
#    :pod_target_xcconfig => {"CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES", "GCC_PRECOMPILE_PREFIX_HEADER" => "YES", "COMPILER_INDEX_STORE_ENABLE" => "NO"},
    :sub_dependency => [_Base]
    # :dependency => [
  #       {:name => 'Lianjia_Beike_Base/Beike'},
  #   ]
  }

  _subspecs = [_Base, _All]
  
  _subspecs.each do |spec|
    if spec.delete(:noSource)
      next
    end
    # 拉取源码（如果是 path/branch 形式，则插件认为是开发模式，会拉取源码）
    if ENV["#{s.name}_#{spec[:spec_name]}_SOURCE"] || ENV['IS_SOURCE']
      spec[:source_files] = "#{s.name}/Classes/#{spec[:spec_name]}/**/*.{h,m,mm,c,cpp,cc,pch}"
      spec[:vendored_frameworks] = "#{s.name}/Framework/#{spec[:spec_name]}/*.framework"
      spec[:public_header_files] = ["#{s.name}/**/*.h", "#{s.name}/#{spec[:spec_name]}/**/*.h"]
      # 拉取 framework
    else
      spec[:source_files] = "#{s.name}/Framework/#{spec[:spec_name]}/#{configuration}/*.h"
      spec[:vendored_frameworks] = "#{s.name}/Framework/#{spec[:spec_name]}/#{configuration}/*.framework"
      spec[:public_header_files] = "#{s.name}/Framework/#{spec[:spec_name]}/#{configuration}/*.h"
    end
  end
      
  # 遍历所有的 subspec 对象
  _subspecs.each do |spec|
    s.subspec spec[:spec_name] do |ss|
      
      if spec[:source_files]
          ss.source_files = spec[:source_files]
      end

      if spec[:vendored_libraries]
          ss.vendored_libraries = spec[:vendored_libraries]
      end
      
      if spec[:vendored_frameworks]
          ss.vendored_frameworks = spec[:vendored_frameworks]
      end
      
      if spec[:resource_bundle]
          ss.resource_bundle = spec[:resource_bundle]
      end
      
      if spec[:resources]
        ss.resources = spec[:resources]
      end

      if spec[:public_header_files]
        ss.public_header_files = spec[:public_header_files]
      end
      
      if spec[:pod_target_xcconfig]
        ss.pod_target_xcconfig = spec[:pod_target_xcconfig]
      end
      
      if spec[:sub_dependency]
          spec[:sub_dependency].each do |dep|
              ss.dependency "#{s.name}/#{dep[:spec_name]}"
          end
      end

      if spec[:dependency]
        spec[:dependency].each do |dep|
          if dep.has_key?(:version)
            ss.dependency dep[:name], dep[:version]
          else
            ss.dependency dep[:name]
          end
        end
      end

      _Dependency.each do |depen|
        ss.dependency depen[:name]
      end

      if spec[:frameworks]
        ss.framework = spec[:frameworks]
      end
    end
  end
end
