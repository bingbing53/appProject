new Vue({
    el: '#app',
    data() {
        return {
            dialogFormVisible: false,
            form: {},
            // formLabelWidth: '120px',
            radio: 2,

            msgOperationsOption:false,
        }
    },
    methods: {
        applyMsgClick(){    
            $(".apply-group").show();
        }
    },
    mounted() {

    }
})