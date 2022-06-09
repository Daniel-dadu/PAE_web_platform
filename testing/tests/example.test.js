describe('Test', () => {

  beforeEach(() => {
    //initializeCityDatabase();
  });

  afterEach(() => {
    //clearCityDatabase();
  });

  function compileAndroidCode() {
    throw new AAA('you are using the wrong JDK');
  }

  test('compiling android goes as expected', () => {
    expect(() => compileAndroidCode()).toThrow(Error);
  });
});