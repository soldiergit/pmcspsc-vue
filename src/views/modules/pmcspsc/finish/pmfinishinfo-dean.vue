<template>
  <div class="mod-config">
    <el-form :inline="true" :model="dataForm" @keyup.enter.native="getDataList()">
      <el-form-item>
        <el-input v-model="dataForm.key" placeholder="参数名" clearable></el-input>
      </el-form-item>
      <el-form-item>
        <el-button @click="getDataList()">查询</el-button>
      </el-form-item>
    </el-form>
    <el-card>
      <el-radio-group v-model="finishInfoStatus" @change="getDataList">
        <el-radio label="1">未审批</el-radio>
        <el-radio label="2">已通过</el-radio>
        <el-radio label="3">未通过</el-radio>
      </el-radio-group>
    </el-card>
    <el-table
      :data="dataList"
      border
      v-loading="dataListLoading"
      @selection-change="selectionChangeHandle"
      style="width: 100%;">
      <el-table-column
        type="selection"
        header-align="center"
        align="center"
        width="50">
      </el-table-column>
      <el-table-column
        prop="finishInfoId"
        header-align="center"
        align="center"
        label="Id">
      </el-table-column>
      <el-table-column
        prop="itemInfoId"
        header-align="center"
        align="center"
        label="立项项目id">
      </el-table-column>
      <el-table-column
        prop="finishInfoStatus"
        header-align="center"
        align="center"
        label="审核状态">
        <template slot-scope="scope">
          <el-tag type="small" v-if="scope.row.finishInfoStatus === 0"><span>未提交</span></el-tag>
          <el-tag type="small" v-if="scope.row.finishInfoStatus === 1"><span>待审核</span></el-tag>
          <el-tag type="small" v-if="scope.row.finishInfoStatus === 2"><span>通过</span></el-tag>
          <el-tag type="small" v-if="scope.row.finishInfoStatus === 3"><span>未通过</span></el-tag>
        </template>
      </el-table-column>
      <el-table-column
        fixed="right"
        header-align="center"
        align="center"
        width="150"
        label="操作">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click="detailHandle(scope.row.finishInfoId)">详情</el-button>
          <template v-if="scope.row.finishInfoStatus === 1">
            <el-button type="text" size="small" @click="submitHandle(scope.row.finishInfoId,2)">通过</el-button>
            <el-button type="text" size="small" @click="retreatAddHandle(scope.row.finishInfoId)">不通过</el-button>
          </template>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      @size-change="sizeChangeHandle"
      @current-change="currentChangeHandle"
      :current-page="pageIndex"
      :page-sizes="[10, 20, 50, 100]"
      :page-size="pageSize"
      :total="totalPage"
      layout="total, sizes, prev, pager, next, jumper">
    </el-pagination>
    <!-- 弹窗, 新增 / 修改 -->
    <retreat-add v-if="retreatAddVisible" ref="retreatAdd" @refreshDataList="getDataList"></retreat-add>
    <detail v-if="detailVisible" ref="detail" @refreshDataList="getDataList"></detail>
  </div>
</template>

<script>
  import Detail from './detail'
  import RetreatAdd from './pmfinishinforetreat-add-or-update'
  export default {
    data () {
      return {
        finishInfoStatus: '1',
        dataForm: {
          key: ''
        },
        dataList: [],
        pageIndex: 1,
        pageSize: 10,
        totalPage: 0,
        dataListLoading: false,
        dataListSelections: [],
        retreatAddVisible: false,
        detailVisible: false
      }
    },
    components: {
      Detail,
      RetreatAdd
    },
    activated () {
      this.getDataList()
    },
    methods: {
      // 获取数据列表
      getDataList () {
        this.dataListLoading = true
        this.$http({
          url: this.$http.adornUrl('/pm/finish/list'),
          method: 'get',
          params: this.$http.adornParams({
            'page': this.pageIndex,
            'limit': this.pageSize,
            'finishInfoStatus': this.finishInfoStatus,
            'key': this.dataForm.key
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
        })
      },
      // 每页数
      sizeChangeHandle (val) {
        this.pageSize = val
        this.pageIndex = 1
        this.getDataList()
      },
      // 当前页
      currentChangeHandle (val) {
        this.pageIndex = val
        this.getDataList()
      },
      // 多选
      selectionChangeHandle (val) {
        this.dataListSelections = val
      },
      // 新增 / 修改
      addOrUpdateHandle (id) {
        this.addOrUpdateVisible = true
        this.$nextTick(() => {
          this.$refs.addOrUpdate.init(id)
        })
      },
      // 不通过，新增回退
      retreatAddHandle (id) {
        this.retreatAddVisible = true
        this.$nextTick(() => {
          this.$refs.retreatAdd.init(id)
        })
      },
      // 详情
      detailHandle (id) {
        this.detailVisible = true
        this.$nextTick(() => {
          this.$refs.detail.init(id)
        })
      },
      // 审批
      submitHandle (id, status) {
        this.$confirm(`确定提交操作?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$http({
            url: this.$http.adornUrl('/pm/finish/apply'),
            method: 'post',
            params: this.$http.adornParams({
              'id': id,
              'status': status
            })
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.$message({
                message: '操作成功',
                type: 'success',
                duration: 1500,
                onClose: () => {
                  this.getDataList()
                }
              })
            } else {
              this.$message.error(data.msg)
            }
          })
        })
      },
      // 删除
      deleteHandle (id) {
        var ids = id ? [id] : this.dataListSelections.map(item => {
          return item.finishInfoId
        })
        this.$confirm(`确定对[id=${ids.join(',')}]进行[${id ? '删除' : '批量删除'}]操作?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$http({
            url: this.$http.adornUrl('/pm/finish/delete'),
            method: 'post',
            data: this.$http.adornData(ids, false)
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.$message({
                message: '操作成功',
                type: 'success',
                duration: 1500,
                onClose: () => {
                  this.getDataList()
                }
              })
            } else {
              this.$message.error(data.msg)
            }
          })
        })
      }
    }
  }
</script>
