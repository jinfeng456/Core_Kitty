// 将json对象转为key=value形式
export const toDataStr = (params, url) => {
  let dataStr = ""; //数据拼接字符串
  Object.keys(params).forEach(key => {
      dataStr += key + "=" + params[key] + "&";
  });
  if (dataStr !== '') {
      dataStr = dataStr.substr(0, dataStr.lastIndexOf('&'));
      url = url + '?' + dataStr;
  }
  return url;
}
