<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : '修改'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()" label-width="16rem" style="width: 94%; margin: 0 auto">
    <el-form-item label="立项项目id" prop="itemInfoId">
      <el-input v-model="dataForm.itemInfoId" placeholder="立项项目id"></el-input>
    </el-form-item>
    <el-form-item label="删除标识" prop="finishIsDel">
      <el-input v-model="dataForm.finishIsDel" placeholder="删除标识"></el-input>
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
          finishInfoId: 0,
          itemInfoId: '',
          finishIsDel: ''
        },
        dataRule: {
          itemInfoId: [
            { required: true, message: '立项项目id不能为空', trigger: 'blur' }
          ],
          finishIsDel: [
            { required: true, message: '删除标识不能为空', trigger: 'blur' }
          ]
        }
      }
    },
    methods: {
      init (id) {
        this.dataForm.finishInfoId = id || 0
        this.visible = true
        this.$nextTick(() => {
          this.$refs['dataForm'].resetFields()
          if (this.dataForm.finishInfoId) {
            this.$http({
              url: this.$http.adornUrl(`/generator/pmfinishinfo/info/${this.dataForm.finishInfoId}`),
              method: 'get',
              params: this.$http.adornParams()
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.dataForm.itemInfoId = data.pmFinishInfo.itemInfoId
                this.dataForm.finishIsDel = data.pmFinishInfo.finishIsDel
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
              url: this.$http.adornUrl(`/generator/pmfinishinfo/${!this.dataForm.finishInfoId ? 'save' : 'update'}`),
              method: 'post',
              data: this.$http.adornData({
                'finishInfoId': this.dataForm.finishInfoId || undefined,
                'itemInfoId': this.dataForm.itemInfoId,
                'finishIsDel': this.dataForm.finishIsDel
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
