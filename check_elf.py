import os
import sys
import struct
import zipfile

def check_elf_alignment(filepath):
    try:
        with open(filepath, 'rb') as f:
            magic = f.read(4)
            if magic != b'\x7fELF':
                return False, "Not an ELF file"
            
            f.seek(4)
            ei_class = f.read(1)[0]
            is_64 = (ei_class == 2)
            
            f.seek(16)
            e_type, e_machine, e_version = struct.unpack('<HHL', f.read(8))
            
            if is_64:
                e_entry, e_phoff, e_shoff, e_flags, e_ehsize, e_phentsize, e_phnum = struct.unpack('<QQLLSSS', f.read(32))
            else:
                e_entry, e_phoff, e_shoff, e_flags, e_ehsize, e_phentsize, e_phnum = struct.unpack('<LLLLSSS', f.read(24))
            
            f.seek(e_phoff)
            for i in range(e_phnum):
                if is_64:
                    p_type, p_flags, p_offset, p_vaddr, p_paddr, p_filesz, p_memsz, p_align = struct.unpack('<LLQQQQQQ', f.read(56))
                else:
                    p_type, p_offset, p_vaddr, p_paddr, p_filesz, p_memsz, p_flags, p_align = struct.unpack('<LLLLLLLL', f.read(32))
                
                # PT_LOAD is 1
                if p_type == 1:
                    if p_align < 16384:
                        return False, f"Alignment is {p_align} (needs 16384)"
            return True, "Aligned 16KB"
    except Exception as e:
        return False, str(e)

def main():
    apk_path = r"build\app\outputs\bundle\release\app-release.aab"
    extract_dir = "temp_apk_extract"
    
    if not os.path.exists(apk_path):
        print(f"APK not found at {apk_path}")
        return

    print("Extracting APK...")
    with zipfile.ZipFile(apk_path, 'r') as zip_ref:
        for info in zip_ref.infolist():
            if info.filename.endswith(".so"):
                zip_ref.extract(info, extract_dir)
    
    print("Checking alignment of extracted .so files...")
    all_good = True
    for root, dirs, files in os.walk(extract_dir):
        for file in files:
            if file.endswith(".so"):
                path = os.path.join(root, file)
                aligned, reason = check_elf_alignment(path)
                status = "OK" if aligned else f"FAIL ({reason})"
                if not aligned:
                    all_good = False
                print(f"{status}: {file}")

    if all_good:
        print("SUCCESS: All .so files are 16KB aligned!")
    else:
        print("ERROR: Found .so files that are NOT 16KB aligned.")

if __name__ == "__main__":
    main()
