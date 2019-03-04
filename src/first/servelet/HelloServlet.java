package first.servelet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jpl7.JPL;
import org.jpl7.Query;
import org.jpl7.fli.qid_t;



@WebServlet("/HelloServlet")
public class HelloServlet extends HttpServlet implements Runnable {
	private static final long serialVersionUID = 1L;
       
	  Thread searcher;
	  String s2 = "";
	  String s3 = "";

	  public void init() throws ServletException {
	    searcher = new Thread(this);
	    searcher.setPriority(Thread.MIN_PRIORITY);
	    searcher.start();
	  }

	  public void run() {
		  	String t1 = "consult('C:/Users/ASUS/Documents/AmrAhmed/workspace/TrainsWebProlog/src/first/servelet/trains.pl')";
			
			Query e1 = new Query(t1);
		    s2 = t1 + " " + (e1.hasSolution()?"success":"fail");
			
			//String t2 = "trainSchedules(X,Y,Z,A,B).";
			String t2 = "parent(amr).";
			Query e2 = new Query(t2);
			s3 = t2 +" "+ (e2.hasSolution()? "Success":"failll");
	  }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		out.println("Hello worldd");
		 if (s2.equals("")) {
		      out.println("Still searching for first prime...");
		    }
		    else {
		      out.println(s2);
		    }
		 if (s3.equals("")) {
		      out.println("Running...");
		    }
		    else {
		      out.println(s3);
		    }
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		}
	
	 public void destroy() {
		    searcher.stop();
		  }

}
