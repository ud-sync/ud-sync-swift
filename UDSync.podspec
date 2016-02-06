Pod::Spec.new do |s|
  s.name = 'UDSync'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'Making backend synchronizations easier.'
  s.homepage = 'https://github.com/ud-sync/ud-sync-swift'
  s.authors = { 'Alexandre de Oliveira' => 'chavedomundo@gmail.com' }
  s.source = { :git => 'https://github.com/ud-sync/ud-sync-swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'UDSync/*.swift'

  s.requires_arc = true

  s.dependency 'Alamofire', '~> 3.0'
  s.dependency 'SwiftyJSON', '~> 2.2.0'
  s.dependency 'BrightFutures', '~> 1.0.1'
end
