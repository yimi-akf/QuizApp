import { appTasks } from '@ohos/hvigor-ohos-plugin';

// Patch: 修复 Windows 下 java 命令解析到失效的 Oracle java 导致打包工具崩溃
// 1. 将 "java" 替换为 DevEco JBR 的完整路径
// 2. 将 file.encoding 从 GBK 改为 utf-8（app_packing_tool.jar 兼容）
try {
  const path = require('path');
  const fs = require('fs');
  const pkgPath = require.resolve('@ohos/hvigor-ohos-plugin/package.json');
  const pkgDir = path.dirname(pkgPath);
  const jcbMod = require(path.join(pkgDir, 'src', 'builder', 'java-command-builder.js'));
  const JavaCommandBuilder = jcbMod.JavaCommandBuilder;
  if (JavaCommandBuilder && JavaCommandBuilder.prototype) {
    // 定位 JBR java.exe 完整路径
    const jbrBin = 'C:\\Program Files\\Huawei\\DevEco Studio\\jbr\\bin';
    const jbrJava = path.join(jbrBin, 'java.exe');
    let javaFullPath = 'java';
    try {
      if (fs.existsSync(jbrJava)) {
        javaFullPath = jbrJava;
      }
    } catch (e) { /* 使用默认 "java" */ }

    // Patch build(): 把命令首项 "java" 替换为 JBR 完整路径
    const origBuild = JavaCommandBuilder.prototype.build;
    JavaCommandBuilder.prototype.build = function () {
      const result = origBuild.call(this);
      if (result.length > 0 && result[0] === 'java') {
        result[0] = javaFullPath;
      }
      return result;
    };

    // Patch setJavaSystemProperty: GBK → utf-8
    const origSet = JavaCommandBuilder.prototype.setJavaSystemProperty;
    JavaCommandBuilder.prototype.setJavaSystemProperty = function (key: string, value: string) {
      if (key === 'file.encoding' && value === 'GBK') {
        value = 'utf-8';
      }
      return origSet.call(this, key, value);
    };
  }
} catch (e) {
  // patch 失败则忽略，不影响正常构建
}

export default {
  system: appTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins: []       /* Custom plugin to extend the functionality of Hvigor. */
}