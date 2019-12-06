<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible"
    append-to-body>
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()" label-width="80px">
      <el-row>
        <el-col :span="24">
          <el-form-item label="获奖名次" prop="awardInfo">
            <el-select v-model="dataForm.awardInfo" placeholder="请选择">
              <el-option
                v-for="item in awardInfoList"
                :key="item.value"
                :label="item.label"
                :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="24">
          <el-form-item label="获奖名次" prop="awardGrade">
            <el-select v-model="dataForm.awardGrade" placeholder="请选择">
              <el-option
                v-for="item in awardGradeList"
                :key="item.value"
                :label="item.label"
                :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
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
        index: null,
        dataForm: {
          teamId: 0,
          teamCode: '',
          itemInfoId: '',
          itemInfoCode: '',
          matchTitle: '',
          signUpTime: '',
          awardGrade: 0,
          awardInfo: 0,
          teamInfoIsDel: 0,
          pmTeamPersonInfoEntities: []
        },
        dataRule: {
          awardInfo: [
            { required: true, message: '获奖名次不能为空', trigger: 'blur' }
          ],
          awardGrade: [
            { required: true, message: '获奖级别不能为空', trigger: 'blur' }
          ]
        },
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
      init (item, index) {
        this.visible = true
        this.$nextTick(() => {
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
