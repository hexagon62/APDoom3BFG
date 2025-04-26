set filename=RBDOOM-3-BFG-1.6.0.x-lite-win64-yyyymmdd-git-xxxxxxx.7z

copy build\\Release\\RBDoom3BFG.exe .
copy build\\tools\\compilers\\release\\rbdmap.exe .
7z a %filename% RBDoom3BFG.exe rbdmap.exe

7z a %filename% README.md RELEASE-NOTES.md LICENSE.md LICENSE_EXCEPTIONS.md base/devtools.cfg base/modelviewer.cfg base/extract_resources.cfg base/convert_maps_to_valve220.cfg base/def/*.def base/materials/*.mtr base/script/*.script base/textures/common base/textures/editor base/maps/zoomaps -x!generated -xr!autosave -xr!*.xcf -xr!*.blend
7z a %filename% base/maps/game/*_extra_ents.map
7z a %filename% -r base/renderprogs2/dxil/*.bin
7z a %filename% -r base/renderprogs2/spirv/*.bin
7z a %filename% base/_tb/fgd/*.fgd
7z a %filename% base/_tb/ -xr!*.png -xr!*.tga
7z a %filename% base/_bl/*.json

7z a %filename% base/_rbdoom_blood.pk4
7z a %filename% base/_rbdoom_core.pk4

7z a %filename% tools/trenchbroom -xr!TrenchBroom-nomanual* -xr!TrenchBroom.pdb
7z a %filename% tools/optick-profiler
pause
