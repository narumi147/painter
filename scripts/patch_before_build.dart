/// `dart ./scripts/patch_before_build.dart ${{ matrix.target }} ${{ github.ref }}`
void main(List<String> args) {
  print('Patch before build, args=$args');
  print('Nothing to patch, exit.');
}
