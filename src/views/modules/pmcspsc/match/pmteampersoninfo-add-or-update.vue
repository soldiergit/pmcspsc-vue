<template>
  <el-dialog
    :title="!dataForm.id ? '新增成员' : '修改成员'"
    :close-on-click-modal="false"
    :visible.sync="visible"
    append-to-body>
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()" label-width="80px">
      <el-row>
        <!--<el-col :span="12">-->
          <!--<el-form-item label="团队id" prop="personTeamInfoId">-->
            <!--<el-input v-model="dataForm.personTeamInfoId" placeholder="团队id"></el-input>-->
          <!--</el-form-item>-->
        <!--</el-col>-->
        <el-col :span="12">
          <el-form-item label="学号" prop="personCode">
            <el-input v-model="dataForm.personCode" placeholder="学号"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="姓名" prop="personName">
            <el-input v-model="dataForm.personName" placeholder="姓名"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="学院" prop="personInstitute">
            <el-input v-model="dataForm.personInstitute" placeholder="学院"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="班级" prop="personClass">
            <el-input v-model="dataForm.personClass" placeholder="班级"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="年级" prop="personGrade">
            <el-input v-model="dataForm.personGrade" placeholder="年级"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="专业" prop="personMajor">
            <el-input v-model="dataForm.personMajor" placeholder="专业"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="邮箱" prop="personEmail">
            <el-input v-model="dataForm.personEmail" placeholder="邮箱"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="电话" prop="personPhone">
            <el-input v-model="dataForm.personPhone" placeholder="电话"></el-input>
          </el-form-item>
        </el-col>
        <!--<el-col :span="12">-->
          <!--<el-form-item label="删除标识" prop="personInfoIsDel">-->
            <!--<el-input v-model="dataForm.personInfoIsDel" placeholder="删除标识"></el-input>-->
          <!--</el-form-item>-->
        <!--</el-col>-->
      </el-row>
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
          personInfoIsDel: 0
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
        },
        index: ''
      }
    },
    methods: {
      init (item, index) {
        // this.dataForm.personInfoId = id || 0
        this.visible = true
        this.$nextTick(() => {
          this.$refs['dataForm'].resetFields()
          this.index = index
          this.dataForm = JSON.parse(JSON.stringify(item))
        })
      },
      // 表单提交
      dataFormSubmit () {
        this.$refs['dataForm'].validate((valid) => {
          if (valid) {
            this.visible = false
            //  回调父页面中‘@refreshDataList’定义的刷新方法
            this.$emit('refreshDataList', this.dataForm, this.index)
          }
        })
      }
    }
  }
</script>
