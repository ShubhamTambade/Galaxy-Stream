#!/bin/sh
set -e
set -u
set -o pipefail

function on_error {
  echo "$(realpath -mq "${0}"):$1: error: Unexpected failure"
}
trap 'on_error $LINENO' ERR


# This protects against multiple targets copying the same framework dependency at the same time. The solution
# was originally proposed here: https://lists.samba.org/archive/rsync/2008-February/020158.html
RSYNC_PROTECT_TMP_FILES=(--filter "P .*.??????")


variant_for_slice()
{
  case "$1" in
  "AgoraAiEchoCancellationExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraAiEchoCancellationExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraAiEchoCancellationLLExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraAiEchoCancellationLLExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraAiNoiseSuppressionExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraAiNoiseSuppressionExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraAiNoiseSuppressionLLExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraAiNoiseSuppressionLLExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraAudioBeautyExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraAudioBeautyExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraClearVisionExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraClearVisionExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraContentInspectExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraContentInspectExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraFaceCaptureExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraFaceCaptureExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraFaceDetectionExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraFaceDetectionExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraLipSyncExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraLipSyncExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraReplayKitExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraReplayKitExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraRtcKit.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraRtcKit.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "Agorafdkaac.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "Agorafdkaac.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "Agoraffmpeg.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "Agoraffmpeg.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraSoundTouch.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraSoundTouch.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraSpatialAudioExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraSpatialAudioExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraVideoQualityAnalyzerExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraVideoQualityAnalyzerExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraVideoAv1DecoderExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraVideoAv1DecoderExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraVideoAv1EncoderExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraVideoAv1EncoderExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraVideoDecoderExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraVideoDecoderExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "video_dec.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "video_dec.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraVideoEncoderExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraVideoEncoderExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "video_enc.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "video_enc.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  "AgoraVideoSegmentationExtension.xcframework/ios-arm64_armv7")
    echo ""
    ;;
  "AgoraVideoSegmentationExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "simulator"
    ;;
  esac
}

archs_for_slice()
{
  case "$1" in
  "AgoraAiEchoCancellationExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraAiEchoCancellationExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraAiEchoCancellationLLExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraAiEchoCancellationLLExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraAiNoiseSuppressionExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraAiNoiseSuppressionExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraAiNoiseSuppressionLLExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraAiNoiseSuppressionLLExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraAudioBeautyExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraAudioBeautyExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraClearVisionExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraClearVisionExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraContentInspectExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraContentInspectExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraFaceCaptureExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraFaceCaptureExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraFaceDetectionExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraFaceDetectionExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraLipSyncExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraLipSyncExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraReplayKitExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraReplayKitExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraRtcKit.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraRtcKit.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "Agorafdkaac.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "Agorafdkaac.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "Agoraffmpeg.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "Agoraffmpeg.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraSoundTouch.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraSoundTouch.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraSpatialAudioExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraSpatialAudioExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraVideoQualityAnalyzerExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraVideoQualityAnalyzerExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraVideoAv1DecoderExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraVideoAv1DecoderExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraVideoAv1EncoderExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraVideoAv1EncoderExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraVideoDecoderExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraVideoDecoderExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "video_dec.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "video_dec.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraVideoEncoderExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraVideoEncoderExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "video_enc.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "video_enc.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  "AgoraVideoSegmentationExtension.xcframework/ios-arm64_armv7")
    echo "arm64 armv7"
    ;;
  "AgoraVideoSegmentationExtension.xcframework/ios-arm64_x86_64-simulator")
    echo "arm64 x86_64"
    ;;
  esac
}

copy_dir()
{
  local source="$1"
  local destination="$2"

  # Use filter instead of exclude so missing patterns don't throw errors.
  echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" \"${source}*\" \"${destination}\""
  rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" --links --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" "${source}"/* "${destination}"
}

SELECT_SLICE_RETVAL=""

select_slice() {
  local xcframework_name="$1"
  xcframework_name="${xcframework_name##*/}"
  local paths=("${@:2}")
  # Locate the correct slice of the .xcframework for the current architectures
  local target_path=""

  # Split archs on space so we can find a slice that has all the needed archs
  local target_archs=$(echo $ARCHS | tr " " "\n")

  local target_variant=""
  if [[ "$PLATFORM_NAME" == *"simulator" ]]; then
    target_variant="simulator"
  fi
  if [[ ! -z ${EFFECTIVE_PLATFORM_NAME+x} && "$EFFECTIVE_PLATFORM_NAME" == *"maccatalyst" ]]; then
    target_variant="maccatalyst"
  fi
  for i in ${!paths[@]}; do
    local matched_all_archs="1"
    local slice_archs="$(archs_for_slice "${xcframework_name}/${paths[$i]}")"
    local slice_variant="$(variant_for_slice "${xcframework_name}/${paths[$i]}")"
    for target_arch in $target_archs; do
      if ! [[ "${slice_variant}" == "$target_variant" ]]; then
        matched_all_archs="0"
        break
      fi

      if ! echo "${slice_archs}" | tr " " "\n" | grep -F -q -x "$target_arch"; then
        matched_all_archs="0"
        break
      fi
    done

    if [[ "$matched_all_archs" == "1" ]]; then
      # Found a matching slice
      echo "Selected xcframework slice ${paths[$i]}"
      SELECT_SLICE_RETVAL=${paths[$i]}
      break
    fi
  done
}

install_xcframework() {
  local basepath="$1"
  local name="$2"
  local package_type="$3"
  local paths=("${@:4}")

  # Locate the correct slice of the .xcframework for the current architectures
  select_slice "${basepath}" "${paths[@]}"
  local target_path="$SELECT_SLICE_RETVAL"
  if [[ -z "$target_path" ]]; then
    echo "warning: [CP] $(basename ${basepath}): Unable to find matching slice in '${paths[@]}' for the current build architectures ($ARCHS) and platform (${EFFECTIVE_PLATFORM_NAME-${PLATFORM_NAME}})."
    return
  fi
  local source="$basepath/$target_path"

  local destination="${PODS_XCFRAMEWORKS_BUILD_DIR}/${name}"

  if [ ! -d "$destination" ]; then
    mkdir -p "$destination"
  fi

  copy_dir "$source/" "$destination"
  echo "Copied $source to $destination"
}

install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraAiEchoCancellationExtension.xcframework" "AgoraRtcEngine_iOS/AIAEC" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraAiEchoCancellationLLExtension.xcframework" "AgoraRtcEngine_iOS/AIAECLL" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraAiNoiseSuppressionExtension.xcframework" "AgoraRtcEngine_iOS/AINS" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraAiNoiseSuppressionLLExtension.xcframework" "AgoraRtcEngine_iOS/AINSLL" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraAudioBeautyExtension.xcframework" "AgoraRtcEngine_iOS/AudioBeauty" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraClearVisionExtension.xcframework" "AgoraRtcEngine_iOS/ClearVision" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraContentInspectExtension.xcframework" "AgoraRtcEngine_iOS/ContentInspect" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraFaceCaptureExtension.xcframework" "AgoraRtcEngine_iOS/FaceCapture" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraFaceDetectionExtension.xcframework" "AgoraRtcEngine_iOS/FaceDetection" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraLipSyncExtension.xcframework" "AgoraRtcEngine_iOS/LipSync" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraReplayKitExtension.xcframework" "AgoraRtcEngine_iOS/ReplayKit" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraRtcKit.xcframework" "AgoraRtcEngine_iOS/RtcBasic" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/Agorafdkaac.xcframework" "AgoraRtcEngine_iOS/RtcBasic" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/Agoraffmpeg.xcframework" "AgoraRtcEngine_iOS/RtcBasic" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraSoundTouch.xcframework" "AgoraRtcEngine_iOS/RtcBasic" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraSpatialAudioExtension.xcframework" "AgoraRtcEngine_iOS/SpatialAudio" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraVideoQualityAnalyzerExtension.xcframework" "AgoraRtcEngine_iOS/VQA" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraVideoAv1DecoderExtension.xcframework" "AgoraRtcEngine_iOS/VideoAv1CodecDec" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraVideoAv1EncoderExtension.xcframework" "AgoraRtcEngine_iOS/VideoAv1CodecEnc" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraVideoDecoderExtension.xcframework" "AgoraRtcEngine_iOS/VideoCodecDec" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/video_dec.xcframework" "AgoraRtcEngine_iOS/VideoCodecDec" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraVideoEncoderExtension.xcframework" "AgoraRtcEngine_iOS/VideoCodecEnc" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/video_enc.xcframework" "AgoraRtcEngine_iOS/VideoCodecEnc" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"
install_xcframework "${PODS_ROOT}/AgoraRtcEngine_iOS/AgoraVideoSegmentationExtension.xcframework" "AgoraRtcEngine_iOS/VirtualBackground" "framework" "ios-arm64_armv7" "ios-arm64_x86_64-simulator"

