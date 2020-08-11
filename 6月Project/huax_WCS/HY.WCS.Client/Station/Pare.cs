using System;


namespace GK.WCS.Client {
    [Serializable]
    public class Pare
    {
        public Pare(String key,String value) {
            this.key = key;
            this.value = value;
        }
        public string key { get; set; }
        public string value { get; set; }
    }
}