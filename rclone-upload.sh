function add_host_dependencies__rclone() {
	if [[ ${RCLONE_INSTALL_LATEST:-no} != "yes" ]]; then
	  display_alert "add rclone to build deps package list" "${EXTENSION}" "info"
	  declare -g EXTRA_BUILD_DEPS="${EXTRA_BUILD_DEPS} rclone ca-certificates"
	fi

}

function post_build_image__upload_local_with_rclone_010() {

	if [[ ${RCLONE_INSTALL_LATEST:-no} == "yes" ]]; then
          display_alert "installing latest rclone via curl like a heathen" "${EXTENSION}" "warn"
	  run_host_command_logged bash "${EXTENSION_DIR}"/scripts/install_rclone.sh
        fi
}

function post_build_image__upload_local_with_rclone_050() {
	if [[ -n ${RCLONE_LOCAL_TARGET} ]]; then
		declare -g RCLONE_LOG_LEVEL=${RCLONE_LOG_LEVEL:-INFO}
		declare -g RCLONE_LOCAL_CONFIG_NAME="${RCLONE_LOCAL_CONFIG_NAME:-rclone.conf}"
		local RCLONE_CONFIG_PATH="${EXTENSION_DIR}/config/${RCLONE_LOCAL_CONFIG_NAME}"

		display_alert "Uploading Image to ${RCLONE_LOCAL_TARGET} this might take a while" "${EXTENSION}" "info"
		run_host_command_logged rclone --config "${RCLONE_CONFIG_PATH}" sync "${FINAL_IMAGE_FILE}" "${RCLONE_LOCAL_TARGET}" -v --stats-one-line
	fi
}

function run_after_build__upload_publish_with_rclone_20() {
	if [[ -n ${RCLONE_PUBLISH_TARGET} && ${RCLONE_PUBLISH=-no} == "yes" ]]; then

		declare -g RCLONE_LOG_LEVEL=${RCLONE_LOG_LEVEL:-INFO}
		
		local PUBLISH_TARGET="${RCLONE_PUBLISH_TARGET}/${version}"
		local PUBLISH_INCLUDE="${version}.img.*"
		
		declare -g RCLONE_LOCAL_CONFIG_NAME="${RCLONE_PUBLISH_CONFIG_NAME:-rclone.conf}"
		local RCLONE_CONFIG_PATH="${EXTENSION_DIR}/config/${RCLONE_LOCAL_CONFIG_NAME}"
	  
		display_alert "Uploading artifacts to ${RCLONE_PUBLISH_TARGET} this might take a while" "${EXTENSION}" "info"
		run_host_command_logged rclone --config "${RCLONE_CONFIG_PATH}" sync "${FINALDEST}" "${PUBLISH_TARGET}" --include="${PUBLISH_INCLUDE}" -v --stats-one-line
	fi
}
