
Pod::Spec.new do |s|
  s.name         = "JVSlideKit"
  s.version      = "0.0.1"
  s.platform     = :ios, "7.0"
  s.summary      = "A short description of JVSlideKit."
  s.description  = <<-DESC
                   A longer description of JVSlideKit in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  #s.homepage     = "http://EXAMPLE/JVSlideKit"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "javen" => "412775083@qq.com" }
  #s.source       = { :git => "http://EXAMPLE/JVSlideKit.git", :tag => "0.0.1" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"

end
