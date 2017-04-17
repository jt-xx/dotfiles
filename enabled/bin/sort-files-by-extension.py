#!/usr/bin/env python

import os
import shutil
import logging
import argparse

logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s %(name)s %(levelname)s %(message)s',
)
logger = logging.getLogger(__name__)

PREFIX = "__"


def sort_files_in_dir(source_dir):
    basedir = os.path.normpath(os.path.abspath(source_dir))
    for filename in os.listdir(basedir):
        source_path = os.path.join(basedir, filename)
        if os.path.isfile(source_path):  # symlinks are discarded
            fn, ext = os.path.splitext(filename)
            if ext:
                target_dir = os.path.join(basedir, PREFIX + ext[1:].lower())
                if not os.path.exists(target_dir):
                    logger.debug("making %s", target_dir)
                    os.mkdir(target_dir)
                target_path = os.path.join(target_dir, filename)
                if not os.path.exists(target_path) and not os.path.islink(target_path):
                    stat = os.stat(source_path)
                    shutil.move(source_path, target_path)
                    os.utime(target_path, (stat.st_atime, stat.st_mtime))
                else:
                    logger.warning("File %s exists, skipping", target_path)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("source_dir", help="Directory where to sort files by extension")
    args = ap.parse_args()
    sort_files_in_dir(args.source_dir)

if __name__ == "__main__":
    main()
