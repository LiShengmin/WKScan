Pod::Spec.new do |s|
    s.name                  = "WKScan"
    s.version               = "0.1.0"
    s.platform              = :ios, '8.0'
    s.requires_arc          = true
    s.license               = 'MIT'
    s.frameworks            = 'UIKit', 'Foundation'
    s.summary               = "This is scan TVProtocol tool"
    s.description           = <<-DESC
                                This is scan TVProtocol tool!
                                Now sustain DLNAprotocol～
                            DESC
    s.public_header_files   = 'Pod/Help/ScanManager.h'
    s.homepage              = "https://github.com/LiShengmin/WKScan"
    s.author                = { "Ghoul" => "lishengminbj@gmail.com" }
    s.source                = { :git => "https://github.com/LiShengmin/WKScan.git", :tag => s.version.to_s }
    s.source_files          = 'Pod/**/*.{h,m}'
    s.public_header_files   = 'Pod/Help/ScanManager.h'
    s.dependency 'ConnectSDK/Core', '~> 1.6.0'

    s.subspec 'DLNAScan' do |ss|
        ss.source_files = 'Pod/DLNAScan/*.{h,m}'
        ss.public_header_files = 'Pod/DLNAScan/DLNAScanManager.h'
    end

    s.subspec 'Help' do |ss|
        ss.dependency 'WKScan/DLNAScan'
        ss.source_files = 'Pod/Help/*.{h,m}'
        ss.public_header_files = 'Pod/Help/ScanManager.h'
    end


end
