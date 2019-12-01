<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()" label-width="16rem" style="width: 94%; margin: 0 auto">
    <el-form-item label="团队编号" prop="teamCode">
      <el-input v-model="dataForm.teamCode" placeholder="团队编号"></el-input>
    </el-form-item>
    <el-form-item label="立项id" prop="itemInfoId">
      <el-input v-model="dataForm.itemInfoId" placeholder="立项id"></el-input>
    </el-form-item>
    <el-form-item label="项目编号" prop="itemInfoCode">
      <el-input v-model="dataForm.itemInfoCode" placeholder="项目编号"></el-input>
    </el-form-item>
    <el-form-item label="赛题" prop="matchTitle">
      <el-input v-model="dataForm.matchTitle" placeholder="赛题"></el-input>
    </el-form-item>
    <el-form-item label="报名时间" prop="signUpTime">
      <el-input v-model="dataForm.signUpTime" placeholder="报名时间"></el-input>
    </el-form-item>
    <el-form-item label="获奖级别：国家级：区级" prop="awardGrade">
      <el-input v-model="dataForm.awardGrade" placeholder="获奖级别：国家级：区级"></el-input>
    </el-form-item>
    <el-form-item label="获奖" prop="awardInfo">
      <el-input v-model="dataForm.awardInfo" placeholder="获奖"></el-input>
    </el-form-item>
    <el-form-item label="删除标识" prop="teamInfoIsDel">
      <el-input v-model="dataForm.teamInfoIsDel" placeholder="删除标识"></el-input>
    </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" @click="dataFormSubmit()">确定</el-button>
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
          teamCode: '',
          itemInfoId: '',
          itemInfoCode: '',
          matchTitle: '',
          signUpTime: '',
          awardGrade: '',
          awardInfo: '',
          teamInfoIsDel: ''
        },
        dataRule: {
          teamCode: [
            { required: true, message: '团队编号不能为空', trigger: 'blur' }
          ],
          itemInfoId: [
            { required: true, message: '立项id不能为空', trigger: 'blur' }
          ],
          itemInfoCode: [
            { required: true, message: '项目编号不能为空', trigger: 'blur' }
          ],
          matchTitle: [
            { required: true, message: '赛题不能为空', trigger: 'blur' }
          ],
          signUpTime: [
            { required: true, message: '报名时间不能为空', trigger: 'blur' }
          ],
          awardGrade: [
            { required: true, message: '获奖级别：国家级：区级不能为空', trigger: 'blur' }
          ],
          awardInfo: [
            { required: true, message: '获奖不能为空', trigger: 'blur' }
          ],
          teamInfoIsDel: [
            { required: true, message: '删除标识不能为空', trigger: 'blur' }
          ]
        }
      }
    },
    methods: {
      init (id) {
        this.dataForm.teamId = id || 0
        this.visible = true
        this.$nextTick(() => {
          this.$refs['dataForm'].resetFields()
          if (this.dataForm.teamId) {
            this.$http({
              url: this.$http.adornUrl(`/generator/pmteaminfo/info/${this.dataForm.teamId}`),
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
              }
            })
          }
        })
      },
      // 表单提交
      dataFormSubmit () {
        this.$refs['dataForm'].validate((valid) => {
          if (valid) {
            this.$http({
              url: this.$http.adornUrl(`/generator/pmteaminfo/${!this.dataForm.teamId ? 'save' : 'update'}`),
              method: 'post',
              data: this.$http.adornData({
                'teamId': this.dataForm.teamId || undefined,
                'teamCode': this.dataForm.teamCode,
                'itemInfoId': this.dataForm.itemInfoId,
                'itemInfoCode': this.dataForm.itemInfoCode,
                'matchTitle': this.dataForm.matchTitle,
                'signUpTime': this.dataForm.signUpTime,
                'awardGrade': this.dataForm.awardGrade,
                'awardInfo': this.dataForm.awardInfo,
                'teamInfoIsDel': this.dataForm.teamInfoIsDel
              })
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.$message({
                  message: '操作成功',
                  type: 'success',
                  duration: 1500,
                  onClose: () => {
                    this.visible = false
                    this.$emit('refreshDataList')
                  }
                })
              } else {
                this.$message.error(data.msg)
              }
            })
          }
        })
      }
    }
  }
</script>
