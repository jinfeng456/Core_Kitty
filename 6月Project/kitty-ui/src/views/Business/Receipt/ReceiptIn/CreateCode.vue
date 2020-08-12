<template>
  <div id="qrCode" ref="qrCodeDiv"></div>
</template>

<script>
  import QRCode from 'qrcodejs2';
  import { getLodop } from "@/utils/LodopFuncs"
  import { printSelected } from "@/utils/print"
import { printMoudle } from "@/utils/print"

  export default {
    name: "qrCode",
    data() {
      return {}
    },
    mounted: function () {
      this.$nextTick(function () {
        this.bindQRCode();
      })
    },
    methods: {
      bindQRCode: function () {
      var ii=  new QRCode(this.$refs.qrCodeDiv, {
          text: 'acceptanceId / materialCode /materialName/ materialBatch / factoryNo / factoryTime',
          width: 200,
          height: 200,
          colorDark: "#333333", //二维码颜色
          colorLight: "#ffffff", //二维码背景色
          correctLevel: QRCode.CorrectLevel.L//容错率，L/M/H
        })
        printMoudle(ii);
        //  var LODOP = this.LODOPL();
				// 					LODOP.PRINT_INIT("");
				// 					LODOP.NewPage(); 
				// 					LODOP.PRINT_INIT("入库单")
				// 					LODOP.ADD_PRINT_HTM(0, 100, "100%", "100%", ii);
				// 					//if (type === 1) {
				// 						//LODOP.PREVIEW();
        //             LODOP.PRINT_DESIGN();
      },
      LODOPL: function () {
                    var LODOP = getLodop();
                        return LODOP;
                        //layer.msg("请下载Lodop插件", { icon: 5 });
        },
 bindQRCodes: function () {
        var LODOP = this.LODOPL();
									LODOP.PRINT_INIT("");
									LODOP.NewPage(); 
									LODOP.PRINT_INIT("入库单")
									LODOP.ADD_PRINT_HTM(0, 100, "100%", "100%", html);
									//if (type === 1) {
										//LODOP.PREVIEW();
                    LODOP.PRINT_DESIGN();
 }
    }
  }
</script>