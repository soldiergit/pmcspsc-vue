<template>
  <el-dialog
    :title="'详情'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <div id="info">
      <table class="el-table__empty-block" >
        <tr>
          <!--<th colspan="2">id</th>-->
          <!--<td colspan="2"><span v-text="dataForm.teamId"></span></td>-->

          <!--<th colspan="2">指导老师id</th>-->
          <!--<td colspan="2"><span v-text="dataForm.userId"></span></td>-->

          <!--<th colspan="2">立项id</th>-->
          <!--<td colspan="2"><span v-text="dataForm.itemInfoId"></span></td>-->

          <th colspan="2">团队编号</th>
          <td colspan="2"><span v-text="dataForm.teamCode"></span></td>

          <th colspan="2">项目编号</th>
          <td colspan="2"><span v-text="dataForm.itemInfoCode"></span></td>

          <th colspan="2">报名时间</th>
          <td colspan="2"><span v-text="dataForm.signUpTime"></span></td>
        </tr>
        <tr>
          <th colspan="2">赛题</th>
          <td colspan="10"><span v-text="dataForm.matchTitle"></span></td>
        </tr>
        <tr>
          <th colspan="3">获奖名次</th>
          <td colspan="3"><span v-for="(item,index) in awardInfoList" :key="index" v-if="dataForm.awardInfo === item.value" v-text="item.label"></span></td>

          <th colspan="3">获奖级别</th>
          <td colspan="3"><span v-for="(item,index) in awardGradeList" :key="index" v-if="dataForm.awardGrade === item.value" v-text="item.label"></span></td>
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
        <tr v-if="personList.length === 0">
          <td colspan="12"><span v-text="'暂无数据'"></span></td>
        </tr>
        <tr v-if="personList.length > 0" v-for="(item,index) in personList">
          <td><span v-text="item.personCode"></span></td>
          <td colspan="2"><span v-text="item.personName"></span></td>
          <td colspan="2"><span v-text="item.personInstitute"></span></td>
          <td><span v-text="item.personClass"></span></td>
          <td><span v-text="item.personGrade"></span></td>
          <td><span v-text="item.personMajor"></span></td>
          <td colspan="2"><span v-text="item.personEmail"></span></td>
          <td colspan="2"><span v-text="item.personPhone"></span></td>
        </tr>
      </table>
    </div>
    <span slot="footer" class="dialog-footer">
      <el-button type="primary" @click="visible = false">确认</el-button>
    </span>
  </el-dialog>
</template>

<script>
  export default {
    data () {
      return {
        visible: false,
        dataForm: {
          teamId: 0,
          userId: '',
          teamCode: '',
          itemInfoId: '',
          itemInfoCode: '',
          matchTitle: '',
          signUpTime: '',
          awardGrade: '',
          awardInfo: '',
          teamInfoIsDel: 0
        },
        personList: [],
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
        this.dataForm.teamId = id || 0
        this.visible = true
        this.$nextTick(() => {
          // this.$refs['dataForm'].resetFields()
          if (this.dataForm.teamId) {
            this.$http({
              url: this.$http.adornUrl(`/pm/team/info/${this.dataForm.teamId}`),
              method: 'get',
              params: this.$http.adornParams()
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.dataForm.teamCode = data.pmTeamInfo.teamCode
                this.dataForm.itemInfoId = data.pmTeamInfo.itemInfoId
                this.dataForm.itemInfoCode = data.pmTeamInfo.itemInfoCode
                this.dataForm.matchTitle = data.pmTeamInfo.matchTitle
                this.dataForm.signUpTime = data.pmTeamInfo.signUpTime
                this.dataForm.awardGrade = data.pmTeamInfo.awardGrade
                this.dataForm.awardInfo = data.pmTeamInfo.awardInfo
                this.dataForm.teamInfoIsDel = data.pmTeamInfo.teamInfoIsDel
                this.personList = data.pmTeamInfo.pmTeamPersonInfoEntities
              }
            })
          }
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
