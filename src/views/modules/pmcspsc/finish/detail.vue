<template>
  <el-dialog
    :title="'详情'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <div id="info">
      <table class="el-table__empty-block">
        <!--<tr>-->
          <!--<th colspan="2">Id</th>-->
          <!--<td colspan="2"><span v-text="dataForm.finishInfoId"></span></td>-->

          <!--<th colspan="2">立项项目id</th>-->
          <!--<td colspan="2"><span v-text="dataForm.itemInfoId"></span></td>-->

          <!--<th colspan="2">删除标识</th>-->
          <!--<td colspan="2"><span v-text="dataForm.finishIsDel"></span></td>-->

          <!--<th colspan="2">结题人</th>-->
          <!--<td colspan="2"><span v-text="dataForm.userId"></span></td>-->
        <!--</tr>-->
        <!--对应的立项项目 start-->
        <tr>
          <th colspan="12" style="color: red">立项项目信息</th>
        </tr>
        <tr>
          <th colspan="2">立项项目名称</th>
          <td colspan="2"><span v-text="dataForm.pmItemInfoEntity.matchName"></span></td>

          <th colspan="2">组赛单位</th>
          <td colspan="2"><span v-text="dataForm.pmItemInfoEntity.matchUnit"></span></td>

          <th colspan="2">赛制</th>
          <td colspan="2"><span v-for="(item,index) in matchTypeList" :key="index" v-if="dataForm.pmItemInfoEntity.matchType === item.value" v-text="item.label"></span></td>
        </tr>
        <tr>
          <th colspan="2">负责人</th>
          <td colspan="2"><span v-text="dataForm.pmItemInfoEntity.userName"></span></td>

          <th colspan="2">专业</th>
          <td colspan="2"><span v-text="dataForm.pmItemInfoEntity.matchMajor"></span></td>

          <th colspan="2">竞赛主办单位</th>
          <td colspan="2"><span v-text="dataForm.pmItemInfoEntity.hostUnit"></span></td>
        </tr>
        <tr>
          <th colspan="2">竞赛承办单位</th>
          <td colspan="2"><span v-text="dataForm.pmItemInfoEntity.undertakeUnit"></span></td>

          <th colspan="2">申请立项日期</th>
          <td colspan="2"><span v-text="dataForm.pmItemInfoEntity.itemInfoTime"></span></td>

          <th colspan="2">竞赛起始日期</th>
          <td colspan="2"><span v-text="dataForm.pmItemInfoEntity.matchStartTime"></span></td>
        </tr>
        <tr>
          <th colspan="2">竞赛结束日期</th>
          <td colspan="5"><span v-text="dataForm.pmItemInfoEntity.matchEndTime"></span></td>
          <th colspan="2">立项状态</th>
          <td colspan="3">
            <el-tag type="small"><span>通过</span></el-tag>
          </td>
        </tr>
        <tr style="height: auto">
          <th colspan="2">论证组赛的目的和意义</th>
          <td colspan="10" style="line-height: normal"><p><span v-text="dataForm.pmItemInfoEntity.matchSign"></span></p></td>
        </tr>
        <!--对应的立项项目 end-->
        <!--参赛队伍 start-->
        <tr>
          <th colspan="12" style="color: red">各参赛队伍的获奖情况</th>
        </tr>
        <template v-for="(item,index) in teamList">
          <tr>
            <th colspan="2">团队编号</th>
            <td colspan="2"><span v-text="item.teamCode"></span></td>

            <th colspan="2">项目编号</th>
            <td colspan="2"><span v-text="item.itemInfoCode"></span></td>

            <th colspan="2">报名时间</th>
            <td colspan="2"><span v-text="item.signUpTime"></span></td>
          </tr>
          <tr>
            <th colspan="2">赛题</th>
            <td colspan="10"><span v-text="item.matchTitle"></span></td>
          </tr>
          <tr>
            <th colspan="3">获奖名次</th>
            <td colspan="3">
              <el-tag size="mini">
                <span v-for="(awardInfoItem,awardInfoIndex) in awardInfoList" :key="awardInfoIndex" v-if="item.awardInfo === awardInfoItem.value" v-text="awardInfoItem.label"></span>
              </el-tag>
            </td>

            <th colspan="3">获奖级别</th>
            <td colspan="3">
              <el-tag size="mini">
                <span v-for="(awardGradeItem,awardGradeIndex) in awardGradeList" :key="awardGradeIndex" v-if="item.awardGrade === awardGradeItem.value" v-text="awardGradeItem.label"></span>
              </el-tag>
            </td>
          </tr>
          <tr>
            <th>学号</th>
            <th colspan="2">姓名</th>
            <th colspan="2">学院</th>
            <th>班级</th>
            <th>年级</th>
            <th>专业</th>
            <th colspan="2">邮箱</th>
            <th colspan="2">电话</th>
          </tr>
          <tr v-if="item.pmTeamPersonInfoEntities.length === 0">
            <td colspan="12"><span v-text="'暂无数据'"></span></td>
          </tr>
          <tr v-if="item.pmTeamPersonInfoEntities.length > 0" v-for="(personItem,index) in item.pmTeamPersonInfoEntities">
            <td><span v-text="personItem.personCode"></span></td>
            <td colspan="2"><span v-text="personItem.personName"></span></td>
            <td colspan="2"><span v-text="personItem.personInstitute"></span></td>
            <td><span v-text="personItem.personClass"></span></td>
            <td><span v-text="personItem.personGrade"></span></td>
            <td><span v-text="personItem.personMajor"></span></td>
            <td colspan="2"><span v-text="personItem.personEmail"></span></td>
            <td colspan="2"><span v-text="personItem.personPhone"></span></td>
          </tr>
        </template>
        <!--参赛队伍 end-->
        <!--实际预算 start-->
        <tr>
          <th colspan="12" style="color: red">资金实际使用情况</th>
        </tr>
        <tr>
          <th>参赛注册费</th>
          <th>差旅费</th>
          <th>培训费</th>
          <th>评审费</th>
          <th>指导费</th>
          <th>领队费</th>
          <th>组织费</th>
          <th>耗材费</th>
          <th>奖金</th>
          <th>其他费用</th>
          <th colspan="2">合计</th>
        </tr>
        <tr>
          <td><span v-text="dataForm.pmFundInfoEntity.registerCost"></span></td>
          <td><span v-text="dataForm.pmFundInfoEntity.travelCost"></span></td>
          <td><span v-text="dataForm.pmFundInfoEntity.trainCost"></span></td>
          <td><span v-text="dataForm.pmFundInfoEntity.reviewCost"></span></td>
          <td><span v-text="dataForm.pmFundInfoEntity.guideCost"></span></td>
          <td><span v-text="dataForm.pmFundInfoEntity.leaderCost"></span></td>
          <td><span v-text="dataForm.pmFundInfoEntity.organizeCost"></span></td>
          <td><span v-text="dataForm.pmFundInfoEntity.consumablesCost"></span></td>
          <td><span v-text="dataForm.pmFundInfoEntity.awardCost"></span></td>
          <td><span v-text="dataForm.pmFundInfoEntity.anotherCost"></span></td>
          <td colspan="2"><span v-text="dataForm.pmFundInfoEntity.totalCost"></span></td>
        </tr>
        <!--实际预算 end-->
        <tr>
          <th colspan="4">结题状态</th>
          <td colspan="8">
            <el-tag type="small" v-if="dataForm.finishInfoStatus === 0"><span>未提交</span></el-tag>
            <el-tag type="small" v-if="dataForm.finishInfoStatus === 1"><span>待审核</span></el-tag>
            <el-tag type="small" v-if="dataForm.finishInfoStatus === 2"><span>通过</span></el-tag>
            <el-tag type="small" v-if="dataForm.finishInfoStatus === 3"><span>未通过</span></el-tag>
          </td>
        </tr>
      </table>
    </div>
    <table v-if="dataForm.pmFinishAttachEntity!=null&&dataForm.pmFinishAttachEntity.attachPath!=''" align="center" width="100%" border="0" cellpadding="0" cellspacing="0" style="table-layout: fixed;" >
      <tr align="center">
        <th>附件</th>
        <td><span v-text="dataForm.pmFinishAttachEntity.attachName"></span></td>
        <td><el-button @click="downloadAttach" :loading="downloadLoading">下载</el-button></td>
      </tr>
    </table>
    <span slot="footer" class="dialog-footer">
      <el-button v-if="dataForm.userId === this.$store.state.user.id" v-print="'#info'">打印</el-button>
      <el-button type="primary" @click="visible = false">确认</el-button>
    </span>
  </el-dialog>
</template>

<script>
  export default {
    data () {
      return {
        visible: false,
        downloadLoading: false,
        teamList: [],
        fileList: [],
        dataForm: {
          finishInfoId: 0,
          itemInfoId: '',
          finishIsDel: 0,
          userId: '',
          finishInfoStatus: '',
          pmItemInfoEntity: {
            itemInfoId: 0,
            matchName: '',
            matchUnit: '',
            matchType: '',
            userId: '',
            userName: '',
            matchStartTime: '',
            matchEndTime: '',
            matchMajor: '',
            hostUnit: '',
            undertakeUnit: '',
            itemInfoTime: '',
            matchSign: '',
            itemInfoStatus: 0,
            itemInfoFinish: 0,
            itemInfoIsDel: 0
          },
          pmFundInfoEntity: {
            budgetId: 0,
            registerCost: '',
            travelCost: '',
            trainCost: '',
            reviewCost: '',
            guideCost: '',
            leaderCost: '',
            organizeCost: '',
            consumablesCost: '',
            awardCost: '',
            anotherCost: '',
            totalCost: '',
            budgetInfoIsDel: ''
          },
          pmFinishAttachEntity: {
            attachId: '',
            itemInfoId: '',
            attachName: '',
            attachPath: '',
            attachIsDel: ''
          }
        },
        matchTypeList: [
          {value: 0, label: '团体赛'},
          {value: 1, label: '个人赛'}
        ],
        awardGradeList: [
          {value: 1, label: '国家级'},
          {value: 2, label: '区级'},
          {value: 3, label: '校级'}
        ],
        awardInfoList: [
          {value: 1, label: '特等奖'},
          {value: 2, label: '一等奖'},
          {value: 3, label: '二等奖'},
          {value: 4, label: '三等奖'},
          {value: 5, label: '优秀奖'},
          {value: 6, label: '参与奖'},
          {value: 7, label: '无'}
        ]
      }
    },
    methods: {
      init (id) {
        this.dataForm.finishInfoId = id || 0
        this.visible = true
        this.$nextTick(() => {
          // this.$refs['dataForm'].resetFields()
          if (this.dataForm.finishInfoId) {
            this.$http({
              url: this.$http.adornUrl(`/pm/finish/info/${this.dataForm.finishInfoId}`),
              method: 'get',
              params: this.$http.adornParams()
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.dataForm.itemInfoId = data.pmFinishInfo.itemInfoId
                this.dataForm.finishIsDel = data.pmFinishInfo.finishIsDel
                this.dataForm.finishInfoStatus = data.pmFinishInfo.finishInfoStatus
                this.dataForm.pmItemInfoEntity = data.pmFinishInfo.pmItemInfoEntity
                this.teamList = data.pmFinishInfo.pmTeamInfoEntities
                this.dataForm.pmFundInfoEntity = data.pmFinishInfo.pmFundInfoEntity
                this.dataForm.pmFinishAttachEntity = data.pmFinishInfo.pmFinishAttachEntity
                if (this.dataForm.pmFinishAttachEntity !== null && this.dataForm.pmFinishAttachEntity.attachPath !== '') {
                  this.fileList = [{name: data.pmFinishInfo.pmFinishAttachEntity.attachName, url: data.pmFinishInfo.pmFinishAttachEntity.attachPath}]
                }
              }
            })
          }
        })
      },
      // 下载附件
      downloadAttach () {
        this.downloadLoading = true
        this.$http({
          url: this.$http.adornUrl(`/pm/finish/attach/download`),
          method: 'post',
          params: this.$http.adornParams({
            'filePath': this.dataForm.pmFinishAttachEntity.attachPath
          }),
          responseType: 'blob'
        }).then(response => {
          if (!response) {
            this.downloadLoading = false
            return
          }
          let url = window.URL.createObjectURL(new Blob([response.data]))
          let link = document.createElement('a')
          link.style.display = 'none'
          link.href = url
          link.setAttribute('download', this.dataForm.pmFinishAttachEntity.attachName)
          document.body.appendChild(link)
          link.click()
          this.downloadLoading = false
        }).catch(err => {
          console.log(err)
          this.downloadLoading = false
        })
      }
    }
  }
</script>
<style>
  #info table{
    border-right: 1px solid #ebeef5;
    border-bottom: 1px solid #ebeef5;
  }
  #info th{
    border-left: 1px solid #ebeef5;
    border-top: 1px solid #ebeef5;
    white-space: nowrap;
    line-height: 3rem;
  }
  #info td{
    border-left: 1px solid #ebeef5;
    border-top: 1px solid #ebeef5;
    line-height: 3rem;
  }
  #info tr{
    border: 1px solid #ebeef5;
    padding: 10px 0;
  }
  #info p{
    text-indent:2em;
  }
</style>
