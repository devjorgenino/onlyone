<div class="container-fluid mt-5 mb-3">
        <!--h3 class="text-center">Calculadora</h3-->
        <center>
                <div class="contenedor">
                        <form>
                                <table>
                                        <tr>
                                                <td colspan="4"><input class="text text-center" name="display" id="campodetexto"
                                                                type="text" value=""></td>
                                        </tr>
                                        <tr>
                                                <td><input class="columna1" id="7" type="button" value="7"
                                                                onClick="addChar(this.form.display, '7')"></td>
                                                <td><input class="columna1" id="8" type="button" value="8"
                                                                onClick="addChar(this.form.display, '8')"></td>
                                                <td><input class="columna1" id="9" type="button" value="9"
                                                                onClick="addChar(this.form.display, '9')"></td>
                                                <td><input class="columna2" id="suma" type="button" value="+"
                                                                onClick="addChar(this.form.display, '+')"></td>
                                        </tr>
                                        <tr>
                                                <td><input class="columna1" id="4" type="button" value="4"
                                                                onClick="addChar(this.form.display, '4')"></td>
                                                <td><input class="columna1" id="5" type="button" value="5"
                                                                onClick="addChar(this.form.display, '5')"></td>
                                                <td><input class="columna1" id="6" type="button" value="6"
                                                                onClick="addChar(this.form.display, '6')"></td>
                                                <td><input class="columna2" id="resta" type="button" value="-"
                                                                onClick="addChar(this.form.display, '-')"></td>
                                        </tr>
                                        <tr>
                                                <td><input class="columna1" id="1" type="button" value="1"
                                                                onClick="addChar(this.form.display, '1')"></td>
                                                <td><input class="columna1" id="2" type="button" value="2"
                                                                onClick="addChar(this.form.display, '2')"></td>
                                                <td><input class="columna1" id="3" type="button" value="3"
                                                                onClick="addChar(this.form.display, '3')"></td>
                                                <td><input class="columna2" id="multiplicacion" type="button" value="*"
                                                                onClick="addChar(this.form.display, '*')"></td>
                                        </tr>
                                        <tr>
                                                <td><input class="columna1" id="clear" type="button" value="CE"
                                                                onClick="this.form.display.value = 0 "></td>
                                                <td><input class="columna1" id="0" type="button" value="0"
                                                                onClick="addChar(this.form.display, '0')"></td>
                                                <td><input class="columna1" id="equals" type="button" value="=" onClick="if (checkNum(this.form.display.value))
                                  { compute(this.form) }"></td>
                                                <td><input class="columna2" id="division" type="button" value="/"
                                                                onClick="addChar(this.form.display, '/')"></td>
                                        </tr>
                                </table>
                        </form>
                </div>
        </center>
</div>