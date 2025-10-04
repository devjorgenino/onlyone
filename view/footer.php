          
        </div>
      </div>
      <!-- /.content-wrapper -->

    </div>
    <!-- /#wrapper -->

    <!-- Scroll to Top Button-->
    <a class="scroll-to-top rounded" href="#page-top">
      <i class="fas fa-angle-up"></i>
    </a>
    <?php require_once 'view/modal/cargar_csv.php';?>
    <!-- scripts --
    <script src="assets/js/jquery.min.js"></script-->
        
    <!-- Bootstrap core JavaScript-->
    <script src="assets/vendor/jquery/jquery.min.js"></script>
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="assets/vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Page level plugin JavaScript-->
    <script src="assets/vendor/datatables/jquery.dataTables.js"></script>
    <script src="assets/vendor/datatables/dataTables.bootstrap4.js"></script>

    <script src="assets/vendor/datatables/dataTables.responsive.min.js"></script>
    <script src="assets/vendor/datatables/responsive.bootstrap4.min.js"></script>

    <script src="assets/vendor/buttons-datatable/js/buttons.print.min.js"></script>
    <script src="assets/vendor/buttons-datatable/js/dataTables.buttons.min.js"></script>
    <script src="assets/vendor/buttons-datatable/js/buttons.flash.min.js"></script>
    <script src="assets/vendor/buttons-datatable/js/pdfmake.min.js"></script>
    <script src="assets/vendor/buttons-datatable/js/vfs_fonts.js"></script>
    <script src="assets/vendor/buttons-datatable/js/jszip.min.js"></script>
    <script src="assets/vendor/buttons-datatable/js/buttons.html5.min.js"></script>


    <!-- Custom scripts for all pages-->
    <script src="assets/js/sb-admin.min.js"></script>

    <script>
      var sourceSwap = function () {
        var $this = $(this);
        var newSource = $this.data('alt-src');
        $this.data('alt-src', $this.attr('src'));
        $this.attr('src', newSource);
      }

      $(function () {
        $('img[data-alt-src]').each(function () {
          new Image().src = $(this).data('alt-src');
        }).hover(sourceSwap, sourceSwap);
      });
    </script>

    
    <!--NUEVOS--
    <script src="assets/js/calendar.js"></script>
    <script src="assets/js/calculadora.js"></script-->

    <!--VIEJOS-->
    <script src="assets/vendor/chart.js/Chart.min.js"></script>
    <script src="assets/vendor/chart.js/Chart.bundle.min.js"></script>
    <script src="assets/js/popper.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
    <script src="assets/js/funciones.js"></script>
    <script src="assets/js/main.js"></script>
    <script src="assets/js/graficos.js"></script>
    <script src="assets/js/mascara.js"></script>

  </body>
  
  <!-- Footer --
  <footer class="fixed-bottom bg-white">
    <div class="container my-auto">
      <div class="copyright text-center my-auto">
        <span>Copyright © geekHACK, C.A.</span>
      </div>
    </div>
  </footer>
  !-- End of Footer -->
</html>
