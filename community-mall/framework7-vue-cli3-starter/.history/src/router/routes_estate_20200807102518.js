import Repair from '../pages/estate/repair.vue';
import RepairForm from '../pages/estate/repairForm.vue';
import RepairDetail from '../pages/estate/repairDetail.vue';
import ReportDetail from '../pages/estate/reportDetail.vue';
import Report from '../pages/estate/report.vue';
import ReportForm from '../pages/estate/reportForm.vue';
import Visitor from '../pages/estate/visitor.vue';
import VisitorDetail from '../pages/estate/visitorDetail.vue';
import ApplyDoorAuth from '../pages/estate/applyDoorAuth.vue';
import PhotoIDCard from '../pages/estate/photoIDCard.vue';
import FaceInformation from '../pages/estate/faceInformation.vue';
import Photo from '../pages/estate/photo';
import ResidenceInformation from '../pages/estate/residenceInformation.vue';
import ProofOfResidence from '../pages/estate/proofOfResidence.vue';
import bindEstate from '../pages/estate/bindEstate.vue';
import bindVillage from '../pages/estate/bindVillage.vue';
import doorLog from '../pages/estate/doorLog.vue';
export default [
    {
        path: '/estate/repair',
        component: Repair,
    },
    {
        path: '/estate/RepairForm/forceClose/',
        component: RepairForm,
        meta: { title: "表单" }
    },
    {
        path: '/estate/repairDetail/:id/',
        component: RepairDetail,
    },
    {
        path: '/estate/report',
        component: Report,
    },
    {
        path: '/estate/reportForm/forceClose/',
        component: ReportForm,
    },
    {
        path: '/estate/reportDetail',
        component: ReportDetail,
    },
    {
        path: '/estate/visitor',
        component: Visitor,
    },
    {
        path: '/estate/visitorDetail/:visitorId/',
        component: VisitorDetail,
    },
    {
        path: '/estate/applyDoorAth',
        component: ApplyDoorAuth,
    },
    {
        path: '/estate/photoIDCard',
        component: PhotoIDCard,
    },
    {
        path: '/estate/photo',
        component: Photo,
    },
    {
        path: '/estate/faceInformation',
        component: FaceInformation,
    },
    {
        path: '/estate/residenceInformation',
        component: ResidenceInformation,
    },
    {
        path: '/estate/proofOfResidence',
        component: ProofOfResidence,
    },
    {
        path: '/estate/bindEstate',
        component: bindEstate,
    },
    {
        path: '/estate/bindVillage',
        component: bindVillage,
    },
    {
        path: '/estate/doorLog',
        component: doorLog,
    },
];
