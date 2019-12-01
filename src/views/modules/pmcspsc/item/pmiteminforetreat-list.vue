<template>
  <el-dialog
    :title="回退意见"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-table
      :data="dataList"
      border
      style="width: 100%;">
      <el-table-column
        prop="itemInfoId"
        header-align="center"
        align="center"
        label="序号"
        :width="100">
        <template slot-scope="props">
          <p v-text="props.$index+1"></p>
        </template>
      </el-table-column>
      <el-table-column
        prop="retreatAdvise"
        header-align="center"
        align="center"
        label="回退意见">
      </el-table-column>
    </el-table>
    <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" @click="visible = false">确定</el-button>
    </span>
  </el-dialog>
</template>

<script>
  export default {
    data () {
      return {
        dataList: [],
        visible: false,
        dataForm: {
          retreatId: 0,
          itemInfoId: '',
          retreatAdvise: '',
          retreatIsDel: ''
        }
      }
    },
    methods: {
      init (id) {
        this.dataListLoading = true
        this.$http({
          url: this.$http.adornUrl('/pm/item/retreat/list'),
          method: 'get',
          params: this.$http.adornParams({
            'page': 1,
            'limit': 1000,
            'itemInfoId': id
          })
        }).then(({data}) => {
          if (data && data.code === 0) {
            this.dataList = data.page.list
            this.totalPage = data.page.totalCount
          } else {
            this.dataList = []
            this.totalPage = 0
          }
          this.dataListLoading = false
          this.visible = true
        })
      }
    }
  }
</script>
