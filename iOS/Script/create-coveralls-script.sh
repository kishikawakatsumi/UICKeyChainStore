#!/bin/bash -e

if [[ -z "${CI}" ]]; then
  exit 0
fi

COVERALLS_SCRIPT_PATH="${SRCROOT}/Script/coveralls.sh"
cat > "${COVERALLS_SCRIPT_PATH}" <<EOF
#!/bin/bash -e

cd "${OBJECT_FILE_DIR_normal}/${CURRENT_ARCH}"
for file in *.gcda; do
  gcov "\${file}"
done

coveralls --root "${SRCROOT}/../" -e "iOS" --no-gcov
EOF

chmod +x "${COVERALLS_SCRIPT_PATH}"
