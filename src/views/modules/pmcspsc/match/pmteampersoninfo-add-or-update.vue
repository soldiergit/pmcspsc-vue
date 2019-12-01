<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()" label-width="16rem" style="width: 94%; margin: 0 auto">
    <el-form-item label="团队id" prop="personTeamInfoId">
      <el-input v-model="dataForm.personTeamInfoId" placeholder="团队id"></el-input>
    </el-form-item>
    <el-form-item label="学号" prop="personCode">
      <el-input v-model="dataForm.personCode" placeholder="学号"></el-input>
    </el-form-item>
    <el-form-item label="姓名" prop="personName">
      <el-input v-model="dataForm.personName" placeholder="姓名"></el-input>
    </el-form-item>
    <el-form-item label="学院" prop="personInstitute">
      <el-input v-model="dataForm.personInstitute" placeholder="学院"></el-input>
    </el-form-item>
    <el-form-item label="班级" prop="personClass">
      <el-input v-model="dataForm.personClass" placeholder="班级"></el-input>
    </el-form-item>
    <el-form-item label="年级" prop="personGrade">
      <el-input v-model="dataForm.personGrade" placeholder="年级"></el-input>
    </el-form-item>
    <el-form-item label="专业" prop="personMajor">
      <el-input v-model="dataForm.personMajor" placeholder="专业"></el-input>
    </el-form-item>
    <el-form-item label="邮箱" prop="personEmail">
      <el-input v-model="dataForm.personEmail" placeholder="邮箱"></el-input>
    </el-form-item>
    <el-form-item label="电话" prop="personPhone">
      <el-input v-model="dataForm.personPhone" placeholder="电话"></el-input>
    </el-form-item>
    <el-form-item label="删除标识" prop="personInfoIsDel">
      <el-input v-model="dataForm.personInfoIsDel" placeholder="删除标识"></el-input>
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
          personInfoId: 0,
          personTeamInfoId: '',
          personCode: '',
          personName: '',
          personInstitute: '',
          personClass: '',
          personGrade: '',
          personMajor: '',
          personEmail: '',
          personPhone: '',
          personInfoIsDel: ''
        },
        dataRule: {
          personTeamInfoId: [
            { required: true, message: '团队id不能为空', trigger: 'blur' }
          ],
          personCode: [
            { required: true, message: '学号不能为空', trigger: 'blur' }
          ],
          personName: [
            { required: true, message: '姓名不能为空', trigger: 'blur' }
          ],
          personInstitute: [
            { required: true, message: '学院不能为空', trigger: 'blur' }
          ],
          personClass: [
            { required: true, message: '班级不能为空', trigger: 'blur' }
          ],
          personGrade: [
            { required: true, message: '年级不能为空', trigger: 'blur' }
          ],
          personMajor: [
            { required: true, message: '专业不能为空', trigger: 'blur' }
          ],
          personEmail: [
            { required: true, message: '邮箱不能为空', trigger: 'blur' }
          ],
          personPhone: [
            { required: true, message: '电话不能为空', trigger: 'blur' }
          ],
          personInfoIsDel: [
            { required: true, message: '删除标识不能为空', trigger: 'blur' }
          ]
        }
      }
    },
    methods: {
      init (id) {
        this.dataForm.personInfoId = id || 0
        this.visible = true
        this.$nextTick(() => {
          this.$refs['dataForm'].resetFields()
          if (this.dataForm.personInfoId) {
            this.$http({
              url: this.$http.adornUrl(`/generator/pmteampersoninfo/info/${this.dataForm.personInfoId}`),
              method: 'get',
              params: this.$http.adornParams()
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.dataForm.personTeamInfoId = data.pmTeamPersonInfo.personTeamInfoId
                this.dataForm.personCode = data.pmTeamPersonInfo.personCode
                this.dataForm.personName = data.pmTeamPersonInfo.personName
                this.dataForm.personInstitute = data.pmTeamPersonInfo.personInstitute
                this.dataForm.personClass = data.pmTeamPersonInfo.personClass
                this.dataForm.personGrade = data.pmTeamPersonInfo.personGrade
                this.dataForm.personMajor = data.pmTeamPersonInfo.personMajor
                this.dataForm.personEmail = data.pmTeamPersonInfo.personEmail
                this.dataForm.personPhone = data.pmTeamPersonInfo.personPhone
                this.dataForm.personInfoIsDel = data.pmTeamPersonInfo.personInfoIsDel
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
              url: this.$http.adornUrl(`/generator/pmteampersoninfo/${!this.dataForm.personInfoId ? 'save' : 'update'}`),
              method: 'post',
              data: this.$http.adornData({
                'personInfoId': this.dataForm.personInfoId || undefined,
                'personTeamInfoId': this.dataForm.personTeamInfoId,
                'personCode': this.dataForm.personCode,
                'personName': this.dataForm.personName,
                'personInstitute': this.dataForm.personInstitute,
                'personClass': this.dataForm.personClass,
                'personGrade': this.dataForm.personGrade,
                'personMajor': this.dataForm.personMajor,
                'personEmail': this.dataForm.personEmail,
                'personPhone': this.dataForm.personPhone,
                'personInfoIsDel': this.dataForm.personInfoIsDel
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
